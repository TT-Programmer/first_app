class MicropostsController < ApplicationController
  before_action :set_micropost, only: [:show, :edit, :update, :destroy]

  require 'rubygems'
  require 'twitter'
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

  # GET /microposts
  # GET /microposts.json
  def index
    @microposts = Micropost.eager_load(:user)
  end

  # GET /microposts/1
  # GET /microposts/1.json
  def show
  end

  # GET /microposts/new
  def new
    @micropost = Micropost.new
    @users = User.all
    @users_selected = User.first.id
  end

  # GET /microposts/1/edit
  def edit
    @users = User.all
    @users_selected = @micropost.user_id
  end

  # POST /microposts
  # POST /microposts.json
  def create
    @micropost = Micropost.new(micropost_params)

    respond_to do |format|
      if @micropost.save
        twit("新規：" + @micropost.content)
        format.html { redirect_to @micropost, notice: 'Micropost was successfully created.' }
        format.json { render :show, status: :created, location: @micropost }
      else
        format.html { render :new }
        format.json { render json: @micropost.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /microposts/1
  # PATCH/PUT /microposts/1.json
  def update
    respond_to do |format|
      if @micropost.update(micropost_params)
        twit("編集："+@micropost.content)
        format.html { redirect_to @micropost, notice: 'Micropost was successfully updated.' }
        format.json { render :show, status: :ok, location: @micropost }
      else
        format.html { render :edit }
        format.json { render json: @micropost.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /microposts/1
  # DELETE /microposts/1.json
  def destroy
    twit("削除："+@micropost.content)
    @micropost.destroy
    respond_to do |format|
      format.html { redirect_to microposts_url, notice: 'Micropost was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_micropost
      @micropost = Micropost.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def micropost_params
      params.require(:micropost).permit(:content, :user_id)
    end

    def twit(tweet) ## Twitterへのツイート
      client = Twitter::REST::Client.new do |config|
        config.consumer_key = "uaYZMxFHtKwxc6hMHTGdyNrjo"
        config.consumer_secret = "VZy1Xj4T2z0z1tO3H8MmlV0P8mNKnpf5AGwpCjQkCv7YbDL9wP"
        config.access_token = "4885852592-bRKIY7a907jGBiQibvncor0KghckgKo8NgpvU9E"
        config.access_token_secret = "hSQe3N8CuQV74X8YNp2gplECliTE9E8QxTaO5L66UjkmQ"
      end
      begin
        tweet = (tweet.length > 140) ? tweet[0..139].to_s : tweet
        client.update(tweet.chomp)
      rescue => e
        #ツイートエラー処理
        Rails.logger.error "<<twitter.rake::tweet.update ERROR : #{e.message}>>"
      end
    end
end
