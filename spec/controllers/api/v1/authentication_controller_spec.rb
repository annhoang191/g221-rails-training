require "rails_helper"

RSpec.shared_examples "API response" do
  it "should response with expected result" do
    expect(response).to have_http_status(status)
    expect(response.body).to eq expected.to_json
  end
end

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
              exp: (Time.zone.now + 24.hours.to_i).strftime("%m-%d-%Y %H:%M"),
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

  describe "GET /api/v1/auth/oauth2" do
  end
end
