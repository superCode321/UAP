class Karticle < ActiveRecord::Base
	belongs_to :article
	attr_accessible :article_id, :score
end