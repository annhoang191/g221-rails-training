class NotePresenter < BasePresenter
  def as_json
    json_obj = obj.as_json
    if json_obj.is_a?(Array)
      json_obj.map { |x| x.except("user_id", "created_at") }
    else
      json_obj.except("user_id", "created_at")
    end
  end
end
