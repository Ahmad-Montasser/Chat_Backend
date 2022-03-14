require 'redis'


class NewChatCreate < ApplicationJob
  sidekiq_options queue: :default, retry: 5
  queue_as :default
    
  def perform(params)
    redis = Redis.new(host: "localhost")
    app = Application.where(:app_token => params[:app_token])
    unless app.blank?
        currentChatNumber = redis.get(params[:app_token]).to_i        
        chatParamsWithNoAndAppToken = {"chat_number" => currentChatNumber,"app_token" => params[:app_token],"messageCount" => 0}.to_json        
      chat = Chat.new(JSON.parse(chatParamsWithNoAndAppToken))        
      if chat.save
        updatedChatNo = redis.get(params[:app_token])
        app.update(:chatCount => updatedChatNo)
        redis.incr(params[:app_token])
      else
        raise ActiveRecord::RecordNotFound.new('Not Found')
      end  
    end
  end
end



