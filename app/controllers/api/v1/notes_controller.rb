module Api
  module V1
    class NotesController < ApplicationController
      before_action :authorize_request
      before_action :find_note, only: %i[update destroy]

      def create
        note = current_user.notes.create! note_params
        represent_response NotePresenter.new(note)
      end

      def update
        @note.update_attributes! note_params
        represent_response NotePresenter.new(@note)
      end

      private

      def note_params
        params.permit(:title, :content)
      end

      def find_note
        @note = Note.find params[:id]
      end
    end
  end
end
