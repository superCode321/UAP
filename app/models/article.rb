class Article < ActiveRecord::Base
	attr_accessible :title, :body, :source_url
end
