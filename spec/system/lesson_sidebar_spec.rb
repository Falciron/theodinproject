require 'rails_helper'

RSpec.describe 'Lesson show sidebar' do
  let(:user) { create(:user) }
  let(:course) { create(:course, path: create(:path, default_path: true)) }

  def build_curriculum(course)
    section_one = create(:section, position: 1, course:, title: 'Getting Started')
    section_two = create(:section, position: 2, course:, title: 'Advanced Topics')
    {
      current: create(:lesson, position: 1, section: section_one, title: 'Intro'),
      sibling: create(:lesson, position: 2, section: section_one, title: 'Next Steps'),
      other: create(:lesson, position: 1, section: section_two, title: 'Deep Dive')
    }
  end

  before do
    sign_in(user)
    page.driver.resize(1400, 900)
  end

  it 'highlights the currently viewed lesson' do
    lessons = build_curriculum(course)

    visit lesson_path(lessons[:current])

    within('[data-test-id="lesson-sidebar"]') do
      expect(page).to have_css('a[aria-current="page"]', text: 'Intro')
      expect(page).to have_css('a:not([aria-current])', text: 'Next Steps')
    end
  end

  it 'expands only the section containing the current lesson by default' do
    lessons = build_curriculum(course)

    visit lesson_path(lessons[:current])

    within('[data-test-id="lesson-sidebar"]') do
      expect(page).to have_css('details[open]', text: 'Getting Started')
      expect(page).to have_css('details:not([open])', text: 'Advanced Topics')
    end
  end

  it 're-expands the section for the newly visited lesson' do
    lessons = build_curriculum(course)

    visit lesson_path(lessons[:current])

    within('[data-test-id="lesson-sidebar"]') do
      find('summary', text: 'Advanced Topics').click
      click_link lessons[:other].title
    end

    within('[data-test-id="lesson-sidebar"]') do
      expect(page).to have_css('details[open]', text: 'Advanced Topics')
      expect(page).to have_css('details:not([open])', text: 'Getting Started')
      expect(page).to have_css('a[aria-current="page"]', text: 'Deep Dive')
    end
  end

  it 'shows a solid checkmark for completed lessons' do
    lessons = build_curriculum(course)
    create(:lesson_completion, user:, lesson: lessons[:sibling], course:)

    visit lesson_path(lessons[:current])

    within('[data-test-id="lesson-sidebar"]') do
      within(:xpath, ".//a[normalize-space(.)='Next Steps']/..") do
        expect(page).to have_css('svg.text-teal-600')
      end
    end
  end
end
