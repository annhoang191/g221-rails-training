class NotePresenter < BasePresenter
  def as_json
    obj.as_json.except("user_id", "created_at")
  end
end
