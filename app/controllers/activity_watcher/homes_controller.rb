class ActivityWatcher::HomesController < ActivityWatcher::BaseController

  def index
    respond_to do |format|
      if current_user.Teacher?
        format.html { redirect_to courses_url }
      elsif current_user.Student?
        format.html { redirect_to list_courses_url }
      end
    end
  end

end
