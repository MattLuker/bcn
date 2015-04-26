require 'rails_helper'

describe "Creating posts" do
  let(:user) { create(:user) }

  it 'removes a community from the post' do
    sign_in user, password: 'beans'
    create_community
    expect(page).to have_content('Community was successfully created.')
    community = Community.last

    visit "/posts"
    click_link "New Post"
    expect(page).to have_content("New Post")

    fill_in "Title", with: "My Location Post"
    fill_in "Description", with: "Great new post."

    within("div.communities") do
      select 'Boone Community Network'
    end

    click_button "Save Post"
    expect(page).to have_content("Description: Great new post.")

    click_button 'Remove Community'

    expect(page).to have_content("Community #{community.name} removed.")
  end
end