FactoryBot.define do
  factory :todo_item do
    #περιεχόμενο test item
    content { 'Test Item' }
    completed { false }
    #συνδέεται αυτόματα με ένα test todo
    association :todo
  end
end