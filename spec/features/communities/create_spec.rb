require 'rails_helper'

describe "Adding communities" do

  it "is successful with valid content" do
    create_community

    expect(page).to have_content("Boone Community Network")
    expect(page).to have_content('Community was successfully created.')
  end

  it 'has a log entry after creation' do
    create_community

    log = Log.last

    expect(log.community).to eq(Community.last)
    expect(log.action).to eq("created")

  end
end