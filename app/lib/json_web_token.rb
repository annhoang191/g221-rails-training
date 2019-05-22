class JsonWebToken
  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s

  class << self
    def encode payload, exp = Settings.auth_token.exp_time
      payload[:exp] = exp.to_i
      JWT.encode payload, SECRET_KEY
    end

    def decode token
      decoded_token = JWT.decode(token, SECRET_KEY)[0]
      HashWithIndifferentAccess.new decoded_token
    rescue JWT::ExpiredSignature, JWT::VerificationError => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError, JWT::VerificationError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end
