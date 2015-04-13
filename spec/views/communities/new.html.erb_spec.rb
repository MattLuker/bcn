require 'rails_helper'

RSpec.describe "communities/new", type: :view do
  before(:each) do
    assign(:community, Community.new(
      :name => "MyString",
      :description => "MyString",
      :home_page => "MyString",
      :color => "MyString"
    ))
  end

  it "renders new community form" do
    render

    assert_select "form[action=?][method=?]", communities_path, "post" do

      assert_select "input#community_name[name=?]", "community[name]"

      assert_select "input#community_description[name=?]", "community[description]"

      assert_select "input#community_home_page[name=?]", "community[home_page]"

      assert_select "input#community_color[name=?]", "community[color]"
    end
  end
end
