class ActivityWatcher::UniversitiesController < ActivityWatcher::BaseController
  before_action :set_university, only: [:show, :edit, :update]
  
  def index
    @universities = University.order(:id).page(params[:page])
  end
  
  def show
  end
  
  def new
    @university = University.new()
  end
  
  def edit
  end
  
  def create
    @university = University.new(university_params)
    
    respond_to do |format|
      if @university.save
        format.html { redirect_to universities_url, notice: '大学情報を追加しました' }
      else
        format.html { render :new }
      end
    end
  end
  
  def update
    @university.attributes = university_params
    
    respond_to do |format|
      if @university.save
        format.html { redirect_to universities_url, notice: '大学情報を更新しました' }
      else
        format.html { render :edit }
      end
    end
  end
  
  private
  
  def university_params
    params.require(:university).permit(:name, :name_en, :email_domain, :description)
  end
  
  def set_university
    @university = University.find_by(id: params[:id])
  end
end
