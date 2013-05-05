class Kvector < ActiveRecord::Base
  # Knowledge Vector
  has_one :word
  belongs_to :user
  
  attr_accessible :is_known, :view_count
  
end
