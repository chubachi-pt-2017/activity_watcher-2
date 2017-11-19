FactoryGirl.define do
  factory :user_university do
    confirmation_token "MyString"
    email "MyString"
    student_no "MyString"
    email_confirmed_flg false
    user nil
    university nil
  end
end
