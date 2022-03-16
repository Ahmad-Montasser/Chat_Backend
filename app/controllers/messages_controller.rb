class MessagesController < ApplicationController
  before_action :set_message, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token

  
# Get all messages in a chat by app token & chat number (GET /applications/:token/chats/:chat_number/messages)
def allMessagesInChat
  unless params[:app_token].blank?
    @message = Message.where(:app_token => params[:app_token],:chat_number => params[:chat_number]).as_json(:except => :id)
    render json: @message
  end
end

# Get a specific message in a chat by app token, chat number & message number (GET /applications/:token/chats/:chat_number/messages/message_number)
def specificMessage
  unless params[:app_token].blank? && params[:chat_number].blank? && params[:message_number].blank? 
    @message = Message.where(:app_token => params[:app_token],:chat_number => params[:chat_number],:message_number => params[:message_number]).as_json(:except => :id)
    render json: @message
  end
end

  # Create Message in a chat (POST /applications/:token/chats/:chat_number/messages)
  def create
    redis = Redis.new(host: "redis")
    unless params[:app_token].blank?
      key =params[:app_token]+params[:chat_number].to_s
      if !redis.exists?(key)
        redis.set(key, 1)
      end
      currentMessageNumber = redis.get(key).to_i
      NewMessageCreate.perform_later(params.permit(:app_token,:chat_number,:content),params[:message][:content])
      messageParamsWithNoAndAppToken = {"chat_number" => params[:chat_number],"app_token" => params[:app_token],"message_number" => currentMessageNumber,"content"=> params[:message][:content]}.to_json
      render json: messageParamsWithNoAndAppToken.as_json
    end
  end

  # Update Message in a chat (PUT applications/:app_token/chats/:chat_number/messages/)
  def update
    unless params[:app_token].blank? && params[:chat_number].blank? && params[:message][:content].blank?
    message = Message.where(:app_token => params[:app_token],:chat_number => params[:chat_number],:message_number => params[:message_number]).as_json(:except => :id)
    unless message.blank?
      MessageUpdate.perform_later(message,params[:message][:content])
      messageParamsWithNoAndAppToken = {"chat_number" => message[:chat_number],"app_token" => message[:app_token],"message_number" => message[:message_number],"content"=> params[:message][:content]}.to_json
    render json: messageParamsWithNoAndAppToken.as_json
    end
  end
  end

  def search
    unless params[:query].blank?
     
      @result = Message.searchInMessage( params[:query] ,params[:chat_number])
      response = @result.map{ |item|{message: item[:_source].as_json(:except => :id) }}
       render json: response.as_json
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:content,:chat_number)
    end
end
