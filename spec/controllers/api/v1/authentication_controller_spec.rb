require "rails_helper"
require "shared_examples/api_response"

RSpec.describe Api::V1::AuthenticationController, type: :request do
  describe "POST /api/v1/auth/login" do
    let!(:user) { create(:user) }

    before do
      post "/api/v1/auth/login", params: params
    end

    context "with valid credentials" do
      let(:params) { { email: user.email, password: user.password } }
      let(:token) { JsonWebToken.encode user_id: user.id }

      it_behaves_like "API response" do
        let(:status) { Settings.http_code.code_200 }
        let(:expected) do
          {
            status: true,
            data: {
              token: token,
              exp: (Time.current + 1.day).strftime("%m-%d-%Y %H:%M"),
              email: user.email
            }
          }
        end
      end
    end

    context "when missing email in params" do
      let(:params) { { email: "", password: "Aa@123456" } }
      it_behaves_like "API response" do
        let(:status) { Settings.http_code.code_404 }
        let(:expected) do
          {
            status: false,
            error: {
              error_code: 404,
              message: "Record Not Found",
              errors: "Couldn't find User"
            }
          }
        end
      end
    end

    context "when email does not exist in database" do
      let(:params) { { email: "not exist", password: "Aa@123456" } }
      it_behaves_like "API response" do
        let(:status) { Settings.http_code.code_404 }
        let(:expected) do
          {
            status: false,
            error: {
              error_code: 404,
              message: "Record Not Found",
              errors: "Couldn't find User"
            }
          }
        end
      end
    end

    context "when password is invalid" do
      let(:params) { { email: user.email, password: "wrong password" } }
      it_behaves_like "API response" do
        let(:status) { Settings.http_code.code_401 }
        let(:expected) do
          {
            status: false,
            error: {
              error_code: 401,
              message: "This action is not authorized",
              errors: "Something went wrong with authorized errors"
            }
          }
        end
      end
    end
  end

  describe "GET /api/v1/auth/`provider`/callback" do
    before do
      get "/api/v1/auth/#{provider}/callback"
    end

    let(:provider) { "github" }
    let(:github_url) { "https://example.com/login/oauth/access_token?" }
    let(:client_id) { ENV["GITHUB_CLIENT_ID"] }
    let(:client_secret) { ENV["GITHUB_CLIENT_SECRET"] }

    context "with invalid credentials provided" do
      context "with invalid `client_id`" do
        let(:client_id) { "invalid_client_id" }
        it_behaves_like "API response" do
          let(:status) { Settings.http_code.code_401 }
          let(:expected) do
            {
              "status": false,
              "error": {
                "error_code": 401,
                "message": "This action is not authorized",
                "errors": "Something went wrong with authorized errors"
              }
            }
          end
        end
      end

      context "with invalid `client_secret`" do
        let(:client_secret) { "invalid_client_secret" }
        it_behaves_like "API response" do
          let(:status) { Settings.http_code.code_401 }
          let(:expected) do
            {
              "status": false,
              "error": {
                "error_code": 401,
                "message": "This action is not authorized",
                "errors": "Something went wrong with authorized errors"
              }
            }
          end
        end
      end

      context "with invalid `granted_code`" do
        let(:granted_code) { "invalid_granted_code" }
        it_behaves_like "API response" do
          let(:status) { Settings.http_code.code_401 }
          let(:expected) do
            {
              "status": false,
              "error": {
                "error_code": 401,
                "message": "This action is not authorized",
                "errors": "Something went wrong with authorized errors"
              }
            }
          end
        end
      end
    end

    context "with valid credentials provided" do
      before do
        allow(github_service).to receive(:perform).with(granted_code, provider).and_return(user)
      end

      let(:granted_code) { "12345" }
      let(:user) { create(:user) }
      let(:github_service) { GithubOauthService.new }

      it "find or create an user with Github Oauth service" do
        expect(github_service.perform(granted_code, provider)).to eq(user)
      end
    end
  end
end
