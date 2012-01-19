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
      ev.time_since_question(compare).should == 3.3
    end
  end

  describe "time_since_question_score" do
    let (:dev) {Factory.build :developer}
    it "detects win" do
      dev.stub(:time_since_question).and_return(0)
      dev.time_since_question_score.should == Score::Win

      dev.stub(:time_since_question).and_return(6.0)
      dev.time_since_question_score.should == Score::Win
    end
    
    it "detects Nominal" do
      dev.stub(:time_since_question).and_return(6.1)
      dev.time_since_question_score.should == Score::Nominal

      dev.stub(:time_since_question).and_return(30.0)
      dev.time_since_question_score.should == Score::Nominal
    end
    
    it "detects Weak" do
      dev.stub(:time_since_question).and_return(30.1)
      dev.time_since_question_score.should == Score::Weak

      dev.stub(:time_since_question).and_return(60.9)
      dev.time_since_question_score.should == Score::Weak
    end

    it "detects Fail" do
      dev.stub(:time_since_question).and_return(61.0)
      dev.time_since_question_score.should == Score::Fail

      dev.stub(:time_since_question).and_return(1000.0)
      dev.time_since_question_score.should == Score::Fail
    end
  end

  describe "points_accepted" do
    let (:dev) {Factory.build :developer}
    it "detects win" do
      dev.points_accepted = 5.00
      dev.points_accepted_score.should == Score::Win

      dev.points_accepted = 20.0
      dev.points_accepted_score.should == Score::Win
    end
    
    it "detects Nominal" do
      dev.points_accepted = 3.00
      dev.points_accepted_score.should == Score::Nominal

      dev.points_accepted = 4.99
      dev.points_accepted_score.should == Score::Nominal
    end
    
    it "detects Weak" do
      dev.points_accepted = 1.00
      dev.points_accepted_score.should == Score::Weak

      dev.points_accepted = 2.99
      dev.points_accepted_score.should == Score::Weak
    end

    it "detects Fail" do
      dev.points_accepted = -20
      dev.points_accepted_score.should == Score::Fail

      dev.points_accepted = 0.99
      dev.points_accepted_score.should == Score::Fail
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

  describe "time_since_broke_production_score" do
    let (:dev) {Factory.build :developer}

    it "detects win" do
      dev.stub(:time_since_broke_production).and_return(20.0)
      dev.time_since_broke_production_score.should == Score::Win

      dev.stub(:time_since_broke_production).and_return(1000.0)
      dev.time_since_broke_production_score.should == Score::Win
    end
    
    it "detects Nominal" do
      dev.stub(:time_since_broke_production).and_return(19.9)
      dev.time_since_broke_production_score.should == Score::Nominal

      dev.stub(:time_since_broke_production).and_return(10.0)
      dev.time_since_broke_production_score.should == Score::Nominal
    end
    
    it "detects Weak" do
      dev.stub(:time_since_broke_production).and_return(9.9)
      dev.time_since_broke_production_score.should == Score::Weak

      dev.stub(:time_since_broke_production).and_return(3.0)
      dev.time_since_broke_production_score.should == Score::Weak
    end

    it "detects Fail" do
      dev.stub(:time_since_broke_production).and_return(2.9)
      dev.time_since_broke_production_score.should == Score::Fail

      dev.stub(:time_since_broke_production).and_return(0.0)
      dev.time_since_broke_production_score.should == Score::Fail
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
