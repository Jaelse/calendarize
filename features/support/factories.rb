FactoryGirl.define do
  factory :superadmin, class: Superadmin do
    suadusername "woohoo@ait.asia"
    suadpassword "something123"
    suadpassword_confirmation "something123"
  end

  factory :user, class: User do
    uname "jaelse bhengra"
    uemail "st119370@ait.asia"
    udept "csim"
  end

  factory :secretary, class: Secretary do
    user_id "1"
  end
end
