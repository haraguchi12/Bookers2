class BooksController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]


  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "successfully"
      redirect_to book_path(@book.id)
    else
      @user = User.find_by(id: current_user.id)
      @books = Book.all
      flash.now[:notice] = "can't be blank error"
      render :index
    end
  end


  def index
    @books = Book.all
    @book = Book.new
    @user = User.find_by(id: current_user.id)
  end

  def show
    @book_new=Book.new
    @user = User.find_by(id: current_user.id)
    @book = Book.find(params[:id])
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    @book.user_id = current_user.id
    if @book.update(book_params)
      flash[:notice] = "You have updated book successfully."
       redirect_to book_path(@book.id)
    else
      @books = Book.all
      flash.now[:notice] = "error"
       render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    if current_user.id != @book.user_id
      redirect_to books_path
    end
  end
end
