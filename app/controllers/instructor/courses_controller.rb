class Instructor::CoursesController < ApplicationController
    before_action :authenticate_user!
    before_action :require_authorized_for_current_course, only: [:show]

    # Courses controller for teachers
  
    def new
      @course = Course.new
    end
  
    def create
      @course = current_user.courses.create(course_params)
      if @course.valid?
        redirect_to instructor_course_path(@course)
      else
        render :new, status: :unprocessable_entity
      end
    end
  
    def show
      @section = Section.new
    end
  
    private

    # Validatation
  
    def require_authorized_for_current_course
      if current_course.user != current_user
        render plain: "Unauthorized", status: :unauthorized
        redirect_to course_path(current_course), alert: 'You are not the instructor of that course'
      end
    end
  
    helper_method :current_course

    # Prevents repeating code when calling current_course

    def current_course
      @current_course ||= Course.find(params[:id])
    end

    def course_params
      params.require(:course).permit(:title, :description, :cost, :image)
    end
end