# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :expense do
  	start_date { Time.now }
  	description "Description"
  	comment "Comment"
  	amount 14.5
  end
end
