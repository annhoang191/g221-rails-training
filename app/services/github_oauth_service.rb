class GithubOauthService
  def initialize url, client_id, client_secret
    @url = url
    @client_id = client_id
    @client_secret = client_secret
  end

  def get_access_token granted_code, provider
    access_token_response = Faraday.post "#{@url}client_id=#{@client_id}&client_secret=#{@client_secret}&code=#{granted_code}"
    returned_string = access_token_response.body.split("&")
    response_hash = {}
    returned_string.each do |string|
      key, value = string.split("=")
      response_hash[key] = value
    end

    access_token = response_hash["access_token"]
    user_github_info = Faraday.get "https://api.github.com/user?access_token=#{access_token}"
    auth = JSON.parse(user_github_info.body)

    create_user_from_github_data auth["id"], auth["login"], auth["email"], provider
  end

  private

  def create_user_from_github_data param_uid, name, email, provider
    tmp_password = SecureRandom.base64(8)

    user = User.find_or_create_by uid: param_uid
    user.name = name
    user.email = email
    user.password = tmp_password
    user.password_confirmation = tmp_password
    user.uid = param_uid
    user.provider = provider
    user.save!

    [user]
  end
end
