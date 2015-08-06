require 'rails_helper'

describe "Indexing communities" do
  let(:user) { create(:user, role: 'admin') }

  it "is successful with valid content", :js => true do
    sign_in user, password: 'beans'
    create_community

    expect(page).to have_content("Boone Community Network")

    visit("/communities")

    expect(page).to have_content("We are all part of the Boone community!")
  end
end