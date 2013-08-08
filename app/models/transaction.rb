class Transaction < ActiveRecord::Base
  has_many :events
end
