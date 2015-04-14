require 'rails_helper'

RSpec.describe "communities/index", type: :view do
  before(:each) do
    assign(:communities, [
      Community.create!(
        :name => "Name",
        :description => "Description",
        :home_page => "Home Page",
        :color => "Color"
      ),
      Community.create!(
        :name => "Name 2",
        :description => "Description",
        :home_page => "Home Page",
        :color => "Color"
      )
    ])
  end

  it "renders a list of communities" do
    render
    assert_select "div.community-title", :text => "Name".to_s, :count => 1
    assert_select "div.community-title", :text => "Name 2".to_s, :count => 1

    assert_select 'li', :text => "Description".to_s, :count => 2
    assert_select '[href="/communities"]', :text => "Home Page".to_s, :count => 2
    assert_select "span", :text => "Color".to_s, :count => 2
  end
end
