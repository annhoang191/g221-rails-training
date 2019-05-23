module Api
  module V1
    class NotesController < ApplicationController
      before_action :authorize_request

      def create
        note = current_user.notes.create! note_params
        represent_response NotePresenter.new(note)
      end

      private

      def note_params
        params.permit(:title, :content)
      end
    end
  end
end
