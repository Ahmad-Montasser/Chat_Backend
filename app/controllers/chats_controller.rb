class ChatsController < ApplicationController
  before_action :set_chat, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token

  # Get all chats in an app by app token & chat number (GET /applications/:token/chats/:chat_number)
  def allChatsByApplicationToken
    unless params[:app_token].blank?
      @chat = Chat.where(:app_token => params[:app_token]).as_json(:except => :id)
      render json: @chat
    end
  end

  # Get specific chat By app token & chat number (GET /applications/:token/chats)
  def chatsByApplicationTokenAndAppNumber
    unless params[:app_token].blank? || params[:chat_number].blank?
      @chat = Chat.where('app_token = ? AND chat_number = ?', params[:app_token],params[:chat_number]).as_json(:except => :id)
      render json: @chat
    end
  end

  # Create new chat in a specific app (POST /applications/:token/chats)
  def create
    redis = Redis.new(host: "localhost")
    unless params[:app_token].blank?
      if !redis.exists?(params[:app_token])
        redis.set(params[:app_token], 1)
      end 
      NewChatCreate.perform_later(params.permit(:app_token))
      currentChatNumber = redis.get(params[:app_token]).to_i
      puts currentChatNumber
      chatParamsWithNoAndAppToken = {"chat_number" => currentChatNumber,"app_token" => params[:app_token],"messageCount" => 0}.to_json
      render json: chatParamsWithNoAndAppToken.as_json
    end
  end

  # PATCH/PUT /chats/1 or /chats/1.json
  def update
    respond_to do |format|
      if @chat.update(chat_params)
        format.html { redirect_to chat_url(@chat), notice: "Chat was successfully updated." }
        format.json { render :show, status: :ok, location: @chat }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chats/1 or /chats/1.json
  def destroy
    @chat.destroy

    respond_to do |format|
      format.html { redirect_to chats_url, notice: "Chat was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat
      @chat = Chat.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def chat_params
      chat_params.require(:chat) if chat_params[:chat].present?
    end
end
