require 'rails_helper'

describe 'Listing Users' do
  let(:user) { create(:user) }

  it 'requires login and Admin role to access' do
    sign_in user, password: 'beans'
    user = User.last
    user.role = 'admin'
    user.save

    visit "/users"
    expect(page).to have_content('Listing Users')
  end

  it 'will not allow non-admin users to list users' do
    sign_in user, password: 'beans'
    visit "/users"

    expect(page.current_path).to eq('/home')
  end

  it 'redirects to login if user not logged in' do
    visit '/users'
    expect(page).to have_content('You must be logged in to view that page.')
  end
end