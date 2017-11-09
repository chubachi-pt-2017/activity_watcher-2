FactoryGirl.define do
  factory :comment do
    task nil
    from "MyString"
    body "MyText"
  end
end
