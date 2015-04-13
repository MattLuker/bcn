require 'rails_helper'

describe "Delete communities" do

  it "is successful with valid content" do
    create_community

    expect(page).to have_content("Boone Community Network")
    expect(page).to have_content('Community was successfully created.')

    click_link "Destroy"

    visit('/communities')

    expect(page).to_not have_content('Community was successfully deleted.')
    expect(Community.count).to eq(0)
  end

  it "is successful with valid content and appropriate log" do
    create_community

    click_link "Destroy"

    del_community = Community.only_deleted.last

    expect(del_community.deleted?).to eq(true)
    expect(del_community.deleted_at).to_not eq(nil)
  end
end