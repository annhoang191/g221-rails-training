require "rails_helper"
require_relative "../../lib/error/custom_error"

RSpec.describe GithubOauthService do
  let(:url) { "https://example.com/login/oauth/access_token?" }
  let(:client_id) { ENV["GITHUB_CLIENT_ID"] }
  let(:client_secret) { ENV["GITHUB_CLIENT_SECRET"] }
  let(:granted_code) { "1234" }
  let(:provider) { "github" }
  let(:github_oauth_service) { GithubOauthService.new }

  describe "#perform" do
    context "with invalid provider" do
      let(:provider) { nil }

      subject { github_oauth_service.perform granted_code, provider }
      it "raises error Unauthorized" do
        expect { subject }.to raise_error Error::UnauthorizedError
      end
    end

    context "with invalid grant code" do
      let(:granted_code) { nil }

      subject { github_oauth_service.perform granted_code, provider }
      it "raises error Unauthorized" do
        expect { subject }.to raise_error Error::UnauthorizedError
      end
    end

    context "when missing `client_id`" do
      let(:client_id) { nil }
      let(:github_oauth_service_1) { GithubOauthService.new }
      subject { github_oauth_service.perform granted_code, provider }

      it "raises error Unauthorized" do
        expect { subject }.to raise_error Error::UnauthorizedError
      end
    end

    context "when missing `client_secret`" do
      let(:client_secret) { nil }
      let(:github_oauth_service_2) { GithubOauthService.new }
      subject { github_oauth_service.perform granted_code, provider }

      it "raises error Unauthorized" do
        expect { subject }.to raise_error Error::UnauthorizedError
      end
    end
  end

  describe ".fetch_user_from_github" do
    subject { github_oauth_service.send(:fetch_user_from_github, access_token) }

    context "missing access tokens" do
      let(:access_token) { nil }

      it "requires authentication from  github" do
        expect(subject["message"]).to eq "Requires authentication"
      end
    end
  end

  describe ".create_user_from_github_data" do
    subject { github_oauth_service.send(:create_user_from_github_data, info_data, provider) }
    let(:info_data) do
      {
        login: "anhhq-0547",
        id: 123,
        email: "test@gmail.com"
      }
    end

    context "with valid info data" do
      it "finds or creates an user" do
        is_expected.to be_a(User)
      end
    end

    context "when missing info data" do
      let(:info_data) { nil }
      subject { github_oauth_service.send(:create_user_from_github_data, info_data, provider) }

      it "raises error" do
        expect { subject }.to raise_error
      end
    end
  end
end
