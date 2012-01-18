require 'spec_helper'

describe Developer do
  describe 'validations' do
    it 'works' do
      Factory.build(:developer, name: nil).should_not be_valid
      Factory.build(:developer, name: 'frog', points_accepted: 'harry').should_not be_valid
      Factory.build(:developer, name: 'fred').should be_valid
      Factory.build(:developer, name: 'frog', points_accepted: 3).should be_valid
    end
  end

  describe 'time_since_question' do
    it 'works' do
      ev = Factory :developer, name: 'fred', last_question: '2011-12-07 15:19:00'
      compare = Time.parse('2011-12-07 18:39:00')
      ev.time_since_question(compare).should == 3.333
    end
  end

  describe "time_since_question_score" do
    let (:dev) {Factory.build :developer}
    it "detects Great" do
      dev.stub(:time_since_question).and_return(0)
      dev.time_since_question_score.should == Score::Great

      dev.stub(:time_since_question).and_return(4.0)
      dev.time_since_question_score.should == Score::Great
    end
    
    it "detects Nominal" do
      dev.stub(:time_since_question).and_return(4.1)
      dev.time_since_question_score.should == Score::Nominal

      dev.stub(:time_since_question).and_return(8.0)
      dev.time_since_question_score.should == Score::Nominal
    end
    
    it "detects Weak" do
      dev.stub(:time_since_question).and_return(8.1)
      dev.time_since_question_score.should == Score::Weak

      dev.stub(:time_since_question).and_return(15.9)
      dev.time_since_question_score.should == Score::Weak
    end

    it "detects Fail" do
      dev.stub(:time_since_question).and_return(16.0)
      dev.time_since_question_score.should == Score::Fail

      dev.stub(:time_since_question).and_return(1000.0)
      dev.time_since_question_score.should == Score::Fail
    end
  end

  describe 'time_since_broke_production' do
    it 'works' do
      ev = Factory :developer, name: 'fred', last_broke_production: '2011-12-02 12:19:00'
      compare = Time.parse('2011-12-07 18:39:00')
      ev.time_since_broke_production(compare).should == 5
    end

    it 'rounds to floor' do
      ev = Factory :developer, last_broke_production: '2011-12-07 4:19:00'
      compare = Time.parse('2011-12-7 17:22:00')
      ev.time_since_broke_production(compare).should == 0
    end
  end

  describe 'converted to JSON' do
    it 'includes the desired attributes when converted to JSON' do
      ev = Factory :developer
      ev.to_json.should match /time_since_question/
      ev.to_json.should match /time_since_broke_production/
    end
  end
end
