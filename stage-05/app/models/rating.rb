class Rating < ActiveRecord::Base

  belongs_to :compliment

  validates_presence_of :compliment_id

  validates_inclusion_of :stars, in: 0..5

end
