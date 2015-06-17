require 'rails_helper'

describe "Adding communities" do
  let!(:user) { User.create(email: 'adam@thehoick.com', password: 'beans', first_name: 'Adam', last_name: 'Sommer')}

  it "is successful with valid content" do
    sign_in user, password: 'beans'
    create_community
    community = Community.last

    expect(page).to have_content("Boone Community Network")
    expect(page).to have_content('Community was successfully created.')
    expect(community.created_by).to eq(user.id)
  end
end