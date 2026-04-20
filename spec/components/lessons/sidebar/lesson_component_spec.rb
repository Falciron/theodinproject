require 'rails_helper'

RSpec.describe Lessons::Sidebar::LessonComponent, type: :component do
  it 'renders the lesson title as a link' do
    lesson = create(:lesson, title: 'HTML Basics')

    render_inline(described_class.new(lesson:, current_lesson: lesson))

    expect(page).to have_link('HTML Basics', href: "/lessons/#{lesson.friendly_id}")
  end

  it 'prepends "Project:" for project lessons' do
    lesson = create(:lesson, :project, title: 'Build a Page')

    render_inline(described_class.new(lesson:, current_lesson: lesson))

    expect(page).to have_content('Project: Build a Page')
  end

  context 'when rendered as the current lesson' do
    it 'marks the link with aria-current="page"' do
      lesson = create(:lesson)

      render_inline(described_class.new(lesson:, current_lesson: lesson))

      expect(page).to have_css('a[aria-current="page"]')
    end

    it 'applies highlighted styles' do
      lesson = create(:lesson)

      render_inline(described_class.new(lesson:, current_lesson: lesson))

      expect(page).to have_css('.bg-gray-100')
      expect(page).to have_css('a.font-semibold')
    end
  end

  context 'when rendered as a sibling lesson' do
    it 'does not set aria-current' do
      lesson = create(:lesson)
      other = create(:lesson, section: lesson.section)

      render_inline(described_class.new(lesson:, current_lesson: other))

      expect(page).to have_no_css('a[aria-current]')
      expect(page).to have_no_css('a.font-semibold')
    end
  end

  context 'when a current_user is given' do
    it 'renders a non-interactive completion icon' do
      lesson = create(:lesson)
      user = create(:user)

      render_inline(described_class.new(lesson:, current_lesson: lesson, current_user: user))

      expect(page).to have_css('[data-test-id="lesson-sidebar-completion"]')
      expect(page).to have_no_css('[data-test-id="complete-button"]')
      expect(page).to have_no_css('form')
    end

    it 'uses teal for completed lessons' do
      lesson = create(:lesson)
      lesson.completed = true
      user = create(:user)

      render_inline(described_class.new(lesson:, current_lesson: lesson, current_user: user))

      expect(page).to have_css('[data-test-id="lesson-sidebar-completion"].text-teal-600')
    end

    it 'uses muted gray for incomplete lessons' do
      lesson = create(:lesson)
      user = create(:user)

      render_inline(described_class.new(lesson:, current_lesson: lesson, current_user: user))

      expect(page).to have_css('[data-test-id="lesson-sidebar-completion"].text-gray-300')
    end
  end

  context 'when no current_user is given' do
    it 'does not render the completion icon' do
      lesson = create(:lesson)

      render_inline(described_class.new(lesson:, current_lesson: lesson))

      expect(page).to have_no_css('[data-test-id="lesson-sidebar-completion"]')
    end
  end
end
