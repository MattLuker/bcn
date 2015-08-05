require 'rails_helper'

describe 'Destroy badge' do
  let(:user) { create(:user) }

  it 'destroys a badge', :js => true do
    create_badge
    badge = Badge.last

    visit '/badges/' + badge.id.to_s
    find('.delete_badge').click

    sleep(0.5)
    click_button 'Ok'

    expect(page).to have_content('Badge deleted.')
    expect(Badge.count).to eq(0)
  end

  it 'badge delete button is not available for non-admin users' do
    create_badge
    badge = Badge.last

    click_link 'Log Out'
    sign_in user, password: 'beans'

    visit '/badges/' + badge.id.to_s
    expect(page.assert_no_selector('.delete_badge')).to be_truthy
  end
end