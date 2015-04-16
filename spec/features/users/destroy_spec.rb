require 'rails_helper'

describe 'Deleting User' do
  let(:user) { create(:user) }

  it 'requires login to edit user profile page' do
    visit "/users/#{user.id}"
    expect(page).to have_content('You must be logged in to view that page.')
  end

  it 'allow delete if logged in' do
    sign_in user, password: 'beans'
    expect(User.count).to eq(1)

    visit "/users/#{user.id}"
    expect(page).to have_content('Last name: Slidell')
    click_link 'Destroy'

    expect(User.count).to eq(0)
  end

end