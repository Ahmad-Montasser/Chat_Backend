Rails.application.routes.draw do
  get '/applications', to: 'applications#allApplications'
  get '/applications/:app_token', to: 'applications#applicationByToken'
  get '/applications/:app_token/chats', to: 'chats#allChatsByApplicationToken'
  get '/applications/:app_token/chats/:chat_number', to: 'chats#chatsByApplicationTokenAndAppNumber'
  post '/applications', to: 'applications#create'
  post '/applications/:app_token/chats', to: 'chats#create'
  get '/applications/:app_token/chats/:chat_number/messages', to: 'messages#allMessagesInChat'
  get '/applications/:app_token/chats/:chat_number/messages/:message_number', to: 'messages#specificMessage'
  post '/applications/:app_token/chats/:chat_number/messages', to: 'messages#create'
  
  post '/applications/:app_token/chats/:chat_number/search', to: 'messages#search'
end
