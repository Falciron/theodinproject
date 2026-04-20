require 'rails_helper'

RSpec.describe Lessons::SidebarComponent, type: :component do
  def setup_course
    path = create(:path)
    course = create(:course, path:)
    section_one = create(:section, course:)
    section_two = create(:section, course:)
    lesson_one = create(:lesson, section: section_one)
    lesson_two = create(:lesson, section: section_two)
    { course:, sections: [section_one, section_two], lesson_one:, lesson_two: }
  end

  it 'renders a details element for each section' do
    data = setup_course

    render_inline(described_class.new(
                    course: data[:course],
                    sections: data[:sections],
                    current_lesson: data[:lesson_one],
                  ))

    # Two instances (drawer + desktop), each rendering two <details> = 4 total.
    expect(page).to have_css('details', count: 4)
  end

  it 'opens only the section that contains the current lesson' do
    data = setup_course

    render_inline(described_class.new(
                    course: data[:course],
                    sections: data[:sections],
                    current_lesson: data[:lesson_two],
                  ))

    # The current-lesson section is open in both the drawer and the desktop aside (2 open).
    expect(page).to have_css('details[open]', count: 2)
  end

  it 'renders the off-canvas drawer with a visibility controller' do
    data = setup_course

    render_inline(described_class.new(
                    course: data[:course],
                    sections: data[:sections],
                    current_lesson: data[:lesson_one],
                  ))

    expect(page).to have_css("##{described_class::DRAWER_ID}[data-controller='visibility']")
  end

  it 'renders both the off-canvas drawer and the static desktop aside' do
    data = setup_course

    render_inline(described_class.new(
                    course: data[:course],
                    sections: data[:sections],
                    current_lesson: data[:lesson_one],
                  ))

    expect(page).to have_css('.lesson-sidebar-drawer.xl\\:hidden')
    expect(page).to have_css('aside.hidden.xl\\:block')
  end

  it 'links back to the course via the course title' do
    data = setup_course

    render_inline(described_class.new(
                    course: data[:course],
                    sections: data[:sections],
                    current_lesson: data[:lesson_one],
                  ))

    expect(page).to have_link(data[:course].title, text: data[:course].title, count: 2)
  end

  context 'when a current_user is given' do
    it 'renders a course-progress bar reflecting their completions' do
      data = setup_course
      user = create(:user)
      create(:lesson_completion, user:, lesson: data[:lesson_one], course: data[:course])

      render_inline(described_class.new(
                      course: data[:course],
                      sections: data[:sections],
                      current_lesson: data[:lesson_one],
                      current_user: user,
                    ))

      expect(page).to have_css('[role="progressbar"][aria-valuenow="50"]', count: 2)
      expect(page).to have_text('50% complete', count: 2)
    end
  end

  context 'when no current_user is given' do
    it 'does not render a progress bar' do
      data = setup_course

      render_inline(described_class.new(
                      course: data[:course],
                      sections: data[:sections],
                      current_lesson: data[:lesson_one],
                    ))

      expect(page).to have_no_css('[role="progressbar"]')
    end
  end
end
