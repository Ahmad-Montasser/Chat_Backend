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
    unless chat_params[:app_token].blank?
      allChatsinApp =Chat.where(:app_token => chat_params[:app_token])
      
      if allChatsinApp.blank?
        chatParamsWithNo = chat_params.merge(:chat_number => 1).to_json
      else
        currentChatNumber = allChatsinApp.maximum('chat_number') + 1
        chatParamsWithNo = chat_params.merge(:chat_number => currentChatNumber).to_json
      end          
        @chat = Chat.new(JSON.parse(chatParamsWithNo))        
        if @chat.save
         render json: @chat  
        else
        raise ActiveRecord::RecordNotFound.new('Not Found')
        end
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
      params.permit(:app_token)
    end
end
