require 'rails_helper'

describe "Edit badge" do
  let(:user) { create(:user) }

  it 'updates a badge' do
    create_badge
    badge = Badge.last

    visit '/badges/' + badge.id.to_s
    find('.badge-edit').click

    find('#badge_rules').set('user.username != nil')
    click_button 'Save Badge'

    badge.reload

    expect(page).to have_content('Comment Beginner')
    expect(badge.rules).to eq('user.username != nil')
  end

  it 'disallows navigation to the badge edit page for non-admin users' do
    create_badge
    badge = Badge.last

    click_link 'Log Out'
    sign_in user, password: 'beans'

    visit '/badges/' + badge.id.to_s
    expect(page.assert_no_selector('.badge-edit')).to be_truthy

    visit '/badges/' + badge.id.to_s + '/edit'
    expect(page).to have_content('Page not available.')
  end
end