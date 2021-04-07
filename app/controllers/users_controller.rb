class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]
  
  def show
    @book = Book.new
    @user = User.find(params[:id])
    @books = @user.books
  end
  
  def index
    @users = User.all
    @book = Book.new
    @user = User.find_by(id: current_user.id)
  end
  
  def edit
    @user = User.find_by(id: current_user.id)
  end
  
  def update
    # @book = Book.find(params[:id])
    @user = User.find(params[:id])
   if @user.update(user_params)
     flash[:notice] = "successfully" 
    redirect_to user_path(@user.id)
   else
     flash.now[:notice] = "error"
    render :edit
   end
  end
  
   private

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end
  
  def ensure_correct_user
    if current_user.id != params[:id].to_i
      redirect_to user_path(current_user.id)
    end
  end
  
end