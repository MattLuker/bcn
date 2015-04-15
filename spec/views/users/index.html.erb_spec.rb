require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    assign(:users, [
      User.create!(
        :first_name => "First Name",
        :last_name => "Last Name",
        :email => "adam@thehoick.com",
        :password => "Password Digest"
      ),
      User.create!(
        :first_name => "First Name",
        :last_name => "Last Name",
        :email => "beans@thehoick.com",
        :password => "Password Digest"
      )
    ])
  end

  it "renders a list of users" do
    render
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    assert_select "tr>td", :text => "adam@thehoick.com".to_s, :count => 1
    assert_select "tr>td", :text => "beans@thehoick.com".to_s, :count => 1

  end
end
