class UserPresenter < BasePresenter
  def as_json
    obj.as_json.except("id", "created_at", "updated_at", "password_digest", "provider", "uid")
  end
end
