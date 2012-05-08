#Используя ':user', указываем Factory Girl на необходимость симулировать
#Factory.define :user do |user|
#  user.name "Ruslan"
#  user.email "ruslan@example.com"
#  user.password "qwerty"
#  user.password_confirmation "qwerty"
#end
FactoryGirl.define do
     factory :user do
     name 'Ruslan'
     email 'ruslan@example.com'
     password 'qwerty'
     password_confirmation 'qwerty'
     end
end

FactoryGirl.define do
    sequence :email do |n|
      "person-#{n}@example.com"
      factory :email
  end
end
