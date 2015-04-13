

require 'rails_helper'

describe "Updating communities" do

  it "is successful with valid content" do
    create_community

    expect(page).to have_content("Boone Community Network")

    visit("/communities")

    expect(page).to have_content("We're all part of the Boone community!")
  end
end