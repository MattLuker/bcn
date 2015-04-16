require 'rails_helper'

describe 'Editing User' do
  let(:user) { create(:user) }

  it 'requires login to edit user profile page' do
    visit "/users/#{user.id}/edit"
    expect(page).to have_content('You must be logged in to view that page.')
  end

  it 'allow edit if logged in' do
    sign_in user, password: 'beans'
    visit "/users/#{user.id}/edit"
    expect(find_field('Last name').value).to eq('Slidell')

    fill_in 'Last name', with: 'Barker'
    click_button 'Update Profile'

    expect(page).to have_content('Last name: Barker')
  end
end