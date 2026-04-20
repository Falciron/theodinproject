module Lessons
  class SidebarComponent < ApplicationComponent
    DRAWER_ID = 'lesson-sidebar-drawer'.freeze

    def initialize(course:, sections:, current_lesson:, current_user: nil)
      @course = course
      @sections = sections
      @current_lesson = current_lesson
      @current_user = current_user
    end

    private

    attr_reader :course, :sections, :current_lesson, :current_user

    def progress_percentage
      return nil unless current_user

      course.progress_for(current_user).percentage
    end
  end
end
