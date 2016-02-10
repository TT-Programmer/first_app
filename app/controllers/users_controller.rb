class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  #GET /addr
  def addr
    @users = User.all
  end

  def addr_show
    @user = User.find(params[:id])
  end

  # GET /users/1/contents
  def contents
    @user = User.find(params[:id])
    @microposts = Micropost.where("user_id = " + params[:id])
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    @mode = "new"
  end

  # GET /users/1/edit
  def edit
    @mode = "edit"
  end

  # POST /users
  # POST /users.json
  def create
    @mode = params[:user][:bef_mode]
    puts params[:user][:bef_mode]
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    # @check_password = User.where("id = " + params[:id] + " and password = \"" + params[:user][:now_password] + "\"")
    # if @check_password.nil? || @check_password.size != 1
    #   redirect_to "/users/" + params[:id], error: "パスワードが間違っています。"
    #   return
    # end
    @mode = params[:user][:bef_mode]
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      if params[:user][:bef_mode] == "edit" && params[:user][:password].nil?
        params.require(:user).permit(:name, :email, :tel, :comment)
      else
        params.require(:user).permit(:name, :email, :tel, :comment, :password)
      end
    end
end
