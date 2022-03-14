require 'redis'


class NewMessageCreate < ApplicationJob
  sidekiq_options queue: :default, retry: 1
  queue_as :default
    
  def perform(params,content)
    redis = Redis.new(host: "localhost")
    chat = Chat.where(:app_token => params[:app_token],:chat_number => params[:chat_number])
    puts 'XXXXXXXXXXXXXXXXXXXXXXXx'
    puts params[:app_token]
    puts params[:chat_number]
    
  
    unless chat.blank?
        key = params[:app_token]+params[:chat_number].to_s
        currentMessageNumber = redis.get(key).to_i
        messageParamsWithNoAndAppToken = {"message_number" => currentMessageNumber,"app_token" => params[:app_token],
                "chat_number" =>params[:chat_number],"content" => content}.to_json
        message = Message.new(JSON.parse(messageParamsWithNoAndAppToken))        
        if message.save
            updatedMessageNo = redis.get(key)
            chat.update(:messageCount => updatedMessageNo)   
            redis.incr(key)
        else
            raise ActiveRecord::RecordNotFound.new('Not Found')
        end  
    end
  end

end



