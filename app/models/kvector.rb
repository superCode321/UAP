class Kvector < ActiveRecord::Base
  # Knowledge Vector
  has_one :word
  attr_accessible :is_known, :view_count
  
end
