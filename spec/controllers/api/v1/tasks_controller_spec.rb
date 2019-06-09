require "rails_helper"
require "shared_examples/api_response"

RSpec.describe Api::V1::TasksController, type: :request do
  let!(:user) { create :user }

  before do
    allow_any_instance_of(Api::V1::TasksController).to receive(:authorize_request) { true }
    allow_any_instance_of(Api::V1::TasksController).to receive(:current_user) { user }
  end

  describe "DELETE /api/v1/tasks/:task_id" do
    let!(:task) { create(:task, user_id: user.id) }

    before do
      delete "/api/v1/tasks/#{task_id}"
    end

    context "with invalid path parameters" do
      let!(:task_id) { 0 }

      it_behaves_like "API response" do
        let(:status) { Settings.http_code.code_404 }
        let(:expected) do
          {
            status: false,
            error: {
              error_code: 404,
              message: "Record Not Found",
              errors: "Couldn't find Task with 'id'=0 [WHERE `tasks`.`user_id` = ?]"
            }
          }
        end
      end
    end

    context "with valid path parameters" do
      let(:task_id) { task.id }

      it "deletes successfully with status code 204" do
        expect(response).to have_http_status(Settings.http_code.code_204)
        expect(response.body).to eq ""
      end
    end
  end

  describe "POST /api/vi/tasks" do
    let(:task) { build :task, user: user }

    before do
      post "/api/v1/tasks", params: params
    end

    context "when valid params" do
      let(:params) do
        { content: task.content, status: "unset" }
      end

      it "returns success" do
        expect(Task.count).to eq(1)
        expect(response).to have_http_status(201)
        task = Task.first
        expect(response.body).to eq({
          status: true,
          data: {
            id: task.id,
            user_id: user.id,
            title: task.title,
            content: task.content,
            due_date: task.due_date,
            status: task.status
          }
        }.to_json)
      end
    end

    context "when missing content in params" do
      let(:params) do
        { content: nil, status: "unset" }
      end

      it "returns bad request" do
        expect(Task.count).to eq(0)
        expect(response).to have_http_status(400)
        expect(response.body).to eq({
          status: false,
          error: {
            error_code: 400,
            message: "Record Invalid",
            errors: "Content can't be blank"
          }
        }.to_json)
      end
    end
  end
end
