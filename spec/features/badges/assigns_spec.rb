require 'rails_helper'

describe 'Assigns badge' do
  let(:user) { create(:user) }
  let(:post) { Post.create(title: 'Good Post', description: 'Fun things going on.') }

  it 'assigns a badge to a user when rules are met' do
    create_badge
    badge = Badge.last

    click_link 'Log Out'
    sign_in user, password: 'beans'

    visit post_path(post)
    expect(page).to have_content('Good Post')

    find('.comment-button').click
    find('#comment_content').set('This is fun!!!')
    click_button 'Save Comment'

    expect(user.badges.include?(badge)).to be_truthy
    expect(badge.users[0]).to eq(user)
  end
end
