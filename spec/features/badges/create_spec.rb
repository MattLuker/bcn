require 'rails_helper'

describe "Creating badtes" do
  it "redirects to the badge show page on success" do
    visit '/badges/new'

    fill_in 'Name', with: 'Comment Beginner'
    fill_in 'Rules', with: 'user.comments.count > 5'

    attach_file('badge[image]', Rails.root.join('app/assets/images/five_icon.svg'))

    click_button 'Save Badge'

    expect(Badge.all.count).to eq(1)
    expect(page).to have_content("Comment Beginner")
  end

end