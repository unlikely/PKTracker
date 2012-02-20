# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :story do
    owner_id 1
    tracker_id 1
    estimate 1
    story_type "MyString"
    accepted_at "2012-02-20 16:41:24"
  end
end
