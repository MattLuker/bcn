require 'rails_helper'

describe "Updating communities" do

  it "is successful with valid content" do
    create_community

    expect(page).to have_content("Boone Community Network")
    expect(page).to have_content('Community was successfully created.')

    click_link "Edit"
    fill_in "Color", with: "#ffffff"
    click_button "Save Community"
    expect(page).to have_content('Community was successfully updated.')
  end

  it 'has a log entry after creation' do
    create_community

    click_link "Edit"
    fill_in "Color", with: "#ffffff"
    click_button "Save Community"

    log = Log.last

    expect(log.community).to eq(Community.last)
    expect(log.action).to eq("updated")
  end
end