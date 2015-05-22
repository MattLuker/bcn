require 'rails_helper'

describe 'Showing User' do
  let(:user) { create(:user) }

  it 'requires login to view user profile page' do
    visit('/users/' + user.id.to_s)
    expect(page).to have_content('You must be logged in to view that page.')
  end

  it 'allow show if logged in' do
    sign_in user, password: 'beans'
    visit('/users/' + user.id.to_s)
    expect(page).to have_content('Name: Bob Slidell')
  end
end