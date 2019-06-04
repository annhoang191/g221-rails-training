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
end
