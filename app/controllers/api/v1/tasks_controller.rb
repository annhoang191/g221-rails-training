module Api
  module V1
    class TasksController < ApplicationController
      before_action :authorize_request
      before_action :find_task, only: %i(destroy)

      def destroy
        @task.destroy!
        data = { message: I18n.t("api.v1.tasks.delete_success") }
        represent_response data, Settings.http_code.code_204
      end

      def create
        task = Task.create! task_params
        represent_response TaskPresenter.new(task)
      end

      private

      def task_params
        params.permit(:user_id, :title, :content, :due_date, :status)
      end

      def find_task
        @task = current_user.tasks.find params[:id]
      end
    end
  end
end
