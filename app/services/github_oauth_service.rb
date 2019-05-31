class GithubOauthService
  def initialize
    @url = "https://github.com/login/oauth/access_token?"
    @client_id = ENV["GITHUB_CLIENT_ID"]
    @client_secret = ENV["GITHUB_CLIENT_SECRET"]
  end

  def perform granted_code, provider
    access_token = get_access_token granted_code
    raise Error::UnauthorizedError.new unless access_token

    info_data = fetch_user_from_github access_token
    create_user_from_github_data info_data, provider
  end

  private

  def get_access_token granted_code
    access_token_response = Faraday.post "#{@url}client_id=#{@client_id}&client_secret=#{@client_secret}&code=#{granted_code}"
    CGI::parse(access_token_response.body)["access_token"].first
  end

  def fetch_user_from_github access_token
    user_github_info = Faraday.get "https://api.github.com/user?access_token=#{access_token}"
    JSON.parse user_github_info.body
  end

  def create_user_from_github_data info_data, provider
    user = User.find_or_initialize_by(uid: info_data["id"], provider: provider) do |new_user|
      new_user.name = info_data["login"]
      new_user.email = info_data["email"]
      new_user.uid = info_data["id"]
      new_user.provider = provider
      new_user.save validate: false
    end

    user
  end
end
