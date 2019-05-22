require "rails_helper"

RSpec.describe "API V1 Authentication", type: :request do
  let!(:user) { create(:user) }

  describe "POST /api/v1/auth/login" do
    context "with valid credentials" do
      before(:each) do
        post "/api/v1/auth/login", params: { email: user.email, password: user.password }
      end

      it "return http status ok" do
        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:ok)
      end

      it "return an authentication token with expire date and user info" do
        response_json = JSON.parse response.body
        expect(response_json.keys).to contain_exactly("token", "exp", "email")
        expect(response_json["email"]).to eq(user.email)
      end
    end

    context "with invalid credentials" do
      it "return http status unauthorize if password is wrong" do
        post "/api/v1/auth/login", params: { email: user.email, password: "wrong password" }
        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:unauthorized)
      end

      it "return http status unauthorize if password is not provided" do
        post "/api/v1/auth/login", params: { email: user.email }
        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:unauthorized)
      end

      it "return http status not found user if email doesn't exist" do
        post "/api/v1/auth/login", params: { email: "non existent email", password: user.password }
        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:not_found)
      end

      it "return http status not found user if no credendtials is provided" do
        post "/api/v1/auth/login"
        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
