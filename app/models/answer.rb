require "active_model"

#Active Model Serialization
#http://api.rubyonrails.org/classes/ActiveModel/Serialization.html


class Answer 
  include ActiveModel::Serializers::Xml
  def initialize()
    @response = ""
  end
  
  attr_accessor :response

  def attributes
    {'response' => nil}
  end  

end

