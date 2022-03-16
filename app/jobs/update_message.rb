require 'redis'


class UpdateMessage < ApplicationJob
  
  sidekiq_options queue: :default, retry: 1
  queue_as :default
    
  def perform(message,content)
    unless message.blank?
      message.update(:content => content)  
    end
  end

end
