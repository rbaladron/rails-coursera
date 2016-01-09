class NotesController < ApplicationController
  before_action :set_book, only: [:create, :destroy]

  def create
    @note = @book.notes.new(note_params)
    if @note.save
      redirecto_to @book, notice: "Note succesfully added!"
    else
      redirecto_to @book, alert: "Unnable to add note!"
    end
  end

  def destroy
    @note = @book.notes.find(params[:id])
    @note.destroy
    redirecto_to @book, notice: "Note deleted"
  end

  private
    def set_book
      @book = Book.find(params[:book_id])
    end

    def note_params
      params.require(:note).permit(:title, :note)
    end
end
