FactoryBot.define do
  factory :todo do
    #τίτλος για το test todo
    title { 'Test Todo' }
    description { 'Test Description' }
    #συνδέεται αυτόματα με έναν test user
    association :user
  end
end