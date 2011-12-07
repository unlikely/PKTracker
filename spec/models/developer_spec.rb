require 'spec_helper'

describe Developer do
  describe 'validations' do
    it 'works' do
      Factory.build(:developer, name: nil).should_not be_valid
      Factory.build(:developer, name: 'frog', points_accepted: 'harry').should_not be_valid
    end
  end

  describe 'time_since_question' do
    it 'works' do
      ev = Factory :developer, name: 'fred', last_question: Time.parse('2011-12-07 15:19:00 -500')
      compare = Time.parse('2011-12-07 18:39:00 -500')
      ev.time_since_question(compare).should == 3.333
    end
  end

  describe 'time_since_broke_production' do
    it 'works' do
      ev = Factory :developer, name: 'fred', last_broke_production: Time.parse('2011-12-02 15:19:00 -500')
      compare = Time.parse('2011-12-07 18:39:00 -500')
      ev.time_since_broke_production(compare).should == 5
    end
  end
end
