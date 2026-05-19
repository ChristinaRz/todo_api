FactoryBot.define do
  factory :user do
    #μοναδικό email για κάθε test user
    sequence(:email) { |n| "user#{n}@test.com" }
    password { '123456' }
  end
end