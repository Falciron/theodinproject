require 'rails_helper'

RSpec.describe 'Lesson sidebar' do
  describe 'GET #show' do
    let(:course) { create(:course, path: create(:path, default_path: true)) }
    let(:section) { create(:section, course:) }
    let(:lesson) { create(:lesson, section:) }

    it 'renders the sidebar inside a turbo frame' do
      get lesson_sidebar_path(lesson)

      expect(response).to have_http_status(:success)
      expect(response.body).to include('lesson-sidebar-frame')
      expect(response.body).to include(course.title)
    end

    it 'is accessible to unauthenticated users' do
      get lesson_sidebar_path(lesson)

      expect(response).to have_http_status(:success)
    end

    context 'when signed in' do
      let(:user) { create(:user) }

      before { sign_in(user) }

      it 'marks completed lessons across the whole course' do
        sibling = create(:lesson, section:)
        create(:lesson_completion, user:, lesson: sibling, course:)

        get lesson_sidebar_path(lesson)

        expect(response.body).to include('text-teal-600')
      end
    end
  end
end
