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

def specificMessage
  unless params[:app_token].blank?
    @message = Message.where(:app_token => params[:app_token],:chat_number => params[:chat_number],:message_number => params[:message_number]).as_json(:except => :id)
    render json: @message
  end
end

  # POST /messages or /messages.json
  def create
    unless params[:app_token].blank?
      allMessagesinChat =Message.where(:app_token => params[:app_token],:chat_number => params[:chat_number])

      if allMessagesinChat.blank?
        messageParamsWithNo = message_params.merge(:message_number => 1,:app_token => params[:app_token],:chat_number =>params[:chat_number]).to_json
      else
        currentMessageNumber = allMessagesinChat.maximum('message_number') + 1
        messageParamsWithNo = message_params.merge(:message_number => currentMessageNumber,:app_token => params[:app_token],:chat_number =>params[:chat_number]).to_json
      end          
        @message = Message.new(JSON.parse(messageParamsWithNo))        
        if @message.save
         render json: @message  
        else
        raise ActiveRecord::RecordNotFound.new('Not Found')
        end
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:app_token,:chat_number,:content)
    end
end
