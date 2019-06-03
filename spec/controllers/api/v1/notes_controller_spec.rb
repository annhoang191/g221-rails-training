require "rails_helper"

RSpec.describe Api::V1::Note, type: :request do
  let!(:user) { create :user }
  before do
    allow_any_instance_of(Api::V1::NotesController).to receive(:authorize_request) { true }
    allow_any_instance_of(Api::V1::NotesController).to receive(:current_user) { user }
  end

  describe "POST /api/v1/note" do
    context "when create note " do
      before(:each) do
        post "/api/v1/notes", params: { title: "test", content: "aaaaaaaaaa" }
      end
      it "result success" do
        expect(response.body).to eq({
          status: true,
          data: {
            id: Note.first.id,
            title: "test",
            content: "aaaaaaaaaa",
            updated_at: Note.first.updated_at
          }
        }.to_json)
      end
    end

    context "when params content is missing" do
      before(:each) do
        post "/api/v1/notes", params: { title: "test" }
      end
      it "result success" do
        expect(response.body).to eq({
          status: false,
          error: {
            error_code: 400,
            message: "Record Invalid",
            errors: "Content can't be blank"
          }
        }.to_json)
      end
    end

    context "when params title is missing" do
      before(:each) do
        post "/api/v1/notes", params: { content: "aaaaaaaaaa" }
      end
      it "result success" do
        expect(response.body).to eq({
          status: true,
          data: {
            id: Note.first.id,
            title: nil,
            content: "aaaaaaaaaa",
            updated_at: Note.first.updated_at
          }
        }.to_json)
      end
    end
  end

  describe "Patch /api/v1/note" do
    let!(:note) { create(:note, user_id: user.id) }
    context "when update note" do
      before do
        patch "/api/v1/notes/#{note.id}", params: { title: "test", content: "aaaaaaaaaa" }
      end
      it "result success" do
        expect(response.body).to eq({
          status: true,
          data: {
            id: Note.first.id,
            title: "test",
            content: "aaaaaaaaaa",
            updated_at: Note.first.updated_at
          }
        }.to_json)
      end
    end

    context "when content is null" do
      before do
        patch "/api/v1/notes/#{note.id}", params: { title: "test", content: nil }
      end
      it "return 400" do
        expect(response.body).to eq({
          status: false,
          error: {
            error_code: 400,
            message: "Record Invalid",
            errors: "Content can't be blank"
          }
        }.to_json)
      end
    end

    context "when note not exist" do
      before do
        patch "/api/v1/notes/nil", params: { title: "test", content: "aaaaaaaaaa" }
      end
      it "return 404" do
        expect(response.body).to eq({
          status: false,
          error: {
            error_code: 404,
            message: "Record Not Found",
            errors: "Couldn't find Note with 'id'=nil [WHERE `notes`.`user_id` = ?]"
          }
        }.to_json)
      end
    end
  end
end
