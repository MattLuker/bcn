require 'rails_helper'

RSpec.describe "communities/edit", type: :view do
  before(:each) do
    @community = assign(:community, Community.create!(
      :name => "MyString",
      :description => "MyString",
      :home_page => "MyString",
      :color => "MyString"
    ))
  end

  it "renders the edit community form" do
    render

    assert_select "form[action=?][method=?]", community_path(@community), "post" do

      assert_select "input#community_name[name=?]", "community[name]"

      assert_select "input#community_description[name=?]", "community[description]"

      assert_select "input#community_home_page[name=?]", "community[home_page]"

      assert_select "input#community_color[name=?]", "community[color]"
    end
  end
end
