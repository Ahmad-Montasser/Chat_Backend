class Message < ApplicationRecord
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    def self.searchInMessage(query,chat_number)  
        self.search({
            query: {
                multi_match: {
                    query:    query,
                    fields: [:content]
                }
                        
            }
            
        })
    end
end