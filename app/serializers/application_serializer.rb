class ApplicationSerializer < ActiveModel::Serializer
    attributes :id
    
    def id
        object.hashid unless object.nil?
    end
    
    def index?
      return scope == "index"
    end
    
  end
  