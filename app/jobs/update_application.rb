require 'redis'


class UpdateApplication < ApplicationJob
  
  sidekiq_options queue: :default, retry: 1
  queue_as :default
    
  def perform(application,app_name)
    unless application.blank?
      application.update(:app_name => app_name)  
    end
  end

end