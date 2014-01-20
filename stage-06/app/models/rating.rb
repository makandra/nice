class Rating < ActiveRecord::Base

  belongs_to :compliment
  validates_presence_of :stars

  validates_inclusion_of :stars, in: 0..5

end
