FactoryBot.define do
  factory :user do
    name { "user 1" }
    email { "example1@gmail.com" }
    password { "123456" }
    password_confirmation { "123456" }
  end
end
