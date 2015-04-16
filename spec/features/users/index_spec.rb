require 'rails_helper'

describe 'Listing Users' do
  let(:user) { create(:user) }

  it 'requires login and Admin role to access' do
    pending 'need to add role functionality to Users'

    visit "/users"
    # expect(page).to have_content('You must be logged in to view that page.')
    expect(page).to have_content('Hello Admin')
  end
end