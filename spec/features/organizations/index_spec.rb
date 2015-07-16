require 'rails_helper'

describe "Indexing organizations" do
  let(:user) { create(:user) }

  it "is successful with valid content", :js => true do
    sign_in user, password: 'beans'
    create_organization

    expect(page).to have_content("BCN")

    visit("/organizations")

    expect(page).to have_content("BCN Rulez!")
  end
end