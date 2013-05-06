class Kvector < ActiveRecord::Base
  # Knowledge Vector
  belongs_to :user
  
  attr_accessible :user_id, :word_id, :is_known, :view_count
  
end
