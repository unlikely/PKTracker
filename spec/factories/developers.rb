# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :developer do
    name "MyString"
    points_accepted 1
    last_question "2011-12-06 14:01:06"
    last_broke_production "2011-12-06 14:01:06"
  end
end
