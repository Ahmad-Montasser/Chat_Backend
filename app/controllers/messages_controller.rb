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
  unless params[:app_token].blank?
    @message = Message.where(:app_token => params[:app_token],:chat_number => params[:chat_number],:message_number => params[:message_number]).as_json(:except => :id)
    render json: @message
  end
end

  # Create Message in a chat (POST /applications/:token/chats/:chat_number/messages)
  def create
    redis = Redis.new(host: "localhost")
    unless params[:app_token].blank?
      key =params[:app_token]+params[:chat_number].to_s
      if !redis.exists?(key)
        redis.set(key, 1)
      end
      currentMessageNumber = redis.get(key).to_i
      NewMessageCreate.perform_later(params.permit(:app_token,:chat_number,:content),params[:message][:content])
      puts 'XXXXXXXXXXXXXXXXXx'
      puts currentMessageNumber
      messageParamsWithNoAndAppToken = {"chat_number" => params[:chat_number],"app_token" => params[:app_token],"messageCount" => 0,"message_number" => currentMessageNumber,"content"=> params[:message][:content]}.to_json
      render json: messageParamsWithNoAndAppToken.as_json
    end
  end

  # PATCH/PUT /messages/1 or /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to message_url(@message), notice: "Message was successfully updated." }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1 or /messages/1.json
  def destroy
      if @message.destroy
      render json: @message
      end
  end

  def search
    unless params[:query].blank?
      puts 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
      puts params[:query]
      @result = Message.search( params[:query] )
      render json: @result
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:content)
    end
end
