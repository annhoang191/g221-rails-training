module Api
  module V1
    class NotesController < ApplicationController
      before_action :authorize_request
      before_action :find_note, only: %i[update destroy]

      def index
        note = current_user.notes.order_id.page(params[:page]).per(Settings.per_page.note)
        represent_response NotePresenter.new(note), Settings.http_code.code_200
      end

      def create
        note = current_user.notes.create! note_params
        represent_response NotePresenter.new(note)
      end

      def update
        @note.update_attributes! note_params
        represent_response NotePresenter.new(@note), Settings.http_code.code_200
      end

      private

      def note_params
        params.permit(:title, :content)
      end

      def find_note
        @note = current_user.notes.find params[:id]
      end
    end
  end
end
