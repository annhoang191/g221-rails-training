class TaskPresenter < BasePresenter
  def as_json
    obj.as_json.except("created_at", "updated_at")
  end
end
