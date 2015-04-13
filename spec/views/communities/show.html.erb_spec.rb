require 'rails_helper'

RSpec.describe "communities/show", type: :view do
  before(:each) do
    @community = assign(:community, Community.create!(
      :name => "Name",
      :description => "Description",
      :home_page => "Home Page",
      :color => "Color"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Home Page/)
    expect(rendered).to match(/Color/)
  end
end
