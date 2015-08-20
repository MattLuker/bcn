require 'rails_helper'

describe "Indexing communities" do
  let(:user) { create(:user, role: 'admin') }

  before do
    Role.create(user: user, name: 'admin')
  end

  it "is successful with valid content", :js => true do
    sign_in user, password: 'beans'
    create_community

    expect(page).to have_content("Boone Community Network")

    visit("/communities")

    expect(page).to have_content("Boone Community Network")
  end
end