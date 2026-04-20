module Lessons
  module Sidebar
    class LessonComponent < ApplicationComponent
      def initialize(lesson:, current_lesson:, current_user: nil)
        @lesson = lesson
        @current_lesson = current_lesson
        @current_user = current_user
      end

      private

      attr_reader :lesson, :current_lesson, :current_user

      def current?
        lesson.id == current_lesson.id
      end

      def icon_name
        lesson.is_project? ? 'wrench-screwdriver' : 'book'
      end

      def row_classes
        base = 'flex items-center justify-between gap-2 px-2 py-1.5 rounded-md'
        state = current? ? 'bg-gray-100 dark:bg-gray-800' : 'hover:bg-gray-50 dark:hover:bg-gray-800'
        "#{base} #{state}"
      end

      def link_classes
        base = 'flex items-center gap-2 min-w-0 grow no-underline text-sm'
        color = if current?
                  'font-semibold text-gray-900 dark:text-gray-100'
                else
                  'text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-gray-200'
                end
        "#{base} #{color}"
      end

      def completion_icon_color
        lesson.completed? ? 'text-teal-600' : 'text-gray-300 dark:text-gray-700'
      end

      def completion_icon_title
        lesson.completed? ? 'Lesson completed' : 'Lesson not completed'
      end
    end
  end
end
