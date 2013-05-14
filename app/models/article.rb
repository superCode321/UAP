class Article < ActiveRecord::Base
	has_one :karticle
	attr_accessible :title, :body, :source_url
end
