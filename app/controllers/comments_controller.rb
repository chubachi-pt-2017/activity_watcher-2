class CommentsController < ApplicationController
    def create
    @task = Task.find(params[:task_id])
    @comment = @task.comments.create(params[:comment])
     if @comment.errors.empty?
      redirect_to page_path(params[:task_id])
     else
      @task.comments.delete @comment
      render template: 'home/page'
     end
    end
    
    def destroy
    Comment.destroy(params[:id])
    redirect_to page_path(params[:task_id])
    end
end
