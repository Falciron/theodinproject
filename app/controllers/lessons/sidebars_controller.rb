module Lessons
  class SidebarsController < ApplicationController
    def show
      @lesson = Lesson.find(params[:lesson_id])
      @course = @lesson.course
      @sections = @course.sections.includes(:lessons)

      return unless user_signed_in?

      Courses::MarkCompletedLessons.call(
        user: current_user,
        lessons: @sections.flat_map(&:lessons),
      )
    end
  end
end
