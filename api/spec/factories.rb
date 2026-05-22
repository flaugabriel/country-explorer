# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Omniauth.google[:info][:email] }
    password { 'GN&03i4686#A' }
    password_confirmation { 'GN&03i4686#A' }
  end

  factory :search_history do
    association :user
    country_name { Faker::Address.country }
  end
end
