require "rails_helper"

RSpec.describe Api::V1::UsersController, type: :request do
  describe "POST /api/v1/users" do
    before do
      post "/api/v1/users", params: params
    end

    context "when create new user successful" do
      let(:params) { { name: "UserName1", email: "username1@gmail.com", password: "Aa@123456", password_confirmation: "Aa@123456" } }

      it_behaves_like "API response" do
        let(:status) { Settings.http_code.code_201 }
        let(:expected) do
          {
            status: true,
            data: {
              name: "UserName1",
              email: "username1@gmail.com"
            }
          }
        end
      end
    end

    context "when missing name in params" do
      let(:params) { { name: "", email: "username1@gmail.com", password: "Aa@123456", password_confirmation: "Aa@123456" } }

      it_behaves_like "API response" do
        let(:status) { Settings.http_code.code_400 }
        let(:expected) do
          {
            status: false,
            error: {
              error_code: 400,
              message: "Record Invalid",
              errors: "Name can't be blank"
            }
          }
        end
      end
    end

    context "when missing email in params" do
      let(:params) { { name: "UserName1", email: "", password: "Aa@123456", password_confirmation: "Aa@123456" } }

      it_behaves_like "API response" do
        let(:status) { Settings.http_code.code_400 }
        let(:expected) do
          {
            status: false,
            error: {
              error_code: 400,
              message: "Record Invalid",
              errors: "Email can't be blank, Email is invalid"
            }
          }
        end
      end
    end

    context "when missing password" do
      let(:params) { { name: "UserName1", email: "username1@gmail.com", password: "", password_confirmation: "Aa@123456" } }

      it_behaves_like "API response" do
        let(:status) { Settings.http_code.code_400 }
        let(:expected) do
          {
            status: false,
            error: {
              error_code: 400,
              message: "Record Invalid",
              errors: "Password can't be blank"
            }
          }
        end
      end
    end

    context "when password_confirmation missing or not match with password" do
      let(:params) { { name: "UserName1", email: "username1@gmail.com", password: "Aa@123456", password_confirmation: "" } }

      it_behaves_like "API response" do
        let(:status) { Settings.http_code.code_400 }
        let(:expected) do
          {
            status: false,
            error: {
              error_code: 400,
              message: "Record Invalid",
              errors: "Password confirmation doesn't match Password"
            }
          }
        end
      end
    end
  end
end
