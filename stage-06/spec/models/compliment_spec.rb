require 'spec_helper'

describe Compliment do

  describe '#average_stars' do

    it 'should be nil if there are no ratings' do
      compliment = Compliment.create!(:message => "Your pet loves you too much to ever run away.")
      compliment.average_stars.should be_nil
    end

  end

  describe '#rate' do

    it 'should update the average rating' do
      compliment = Compliment.create!(:message => "Your pet loves you too much to ever run away.")
      compliment.rate(5)
      compliment.average_stars.should == 5.0
      compliment.rate(1)
      compliment.average_stars.should == 3.0
    end

  end

end
