class Article < ActiveRecord::Base
	attr_accessible :title, :body, :source_url

	@@article_index = 0

    def changeIndex(val)
      @@article_index= val
    end
 
    def article_index
      @@article_index
    end
end
