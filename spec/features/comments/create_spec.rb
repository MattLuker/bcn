require 'rails_helper'

describe 'Creating comments' do
  let(:user) { create(:user) }
  let(:post) { Post.create(title: 'Good Post', description: 'Fun things going on.') }

  it 'redirects to the post on success' do
    visit post_path(post)
    expect(page).to have_content('Good Post')

    click_button 'Comment?'
    find('#comment_content').set('This is fun!!!')
    click_button 'Save Comment'

    expect(post.comments.count).to eq(1)
    expect(page).to have_content('Good Post')

    comment = Comment.last
    expect(page).to have_content(comment.content)
  end

  it 'adds the user to the comment if logged in' do
    sign_in user, password: 'beans'

    visit post_path(post)
    expect(page).to have_content('Good Post')

    click_button 'Comment?'
    find('#comment_content').set('This is fun!!!')
    click_button 'Save Comment'

    expect(post.comments.count).to eq(1)
    expect(page).to have_content('Good Post')

    comment = Comment.last
    expect(page).to have_content(comment.content)
    expect(comment.user).to eq(user)
  end
end