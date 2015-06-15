require 'rails_helper'

describe 'Updating comments' do
  let(:user) { create(:user) }
  let(:post) { Post.create(title: 'Good Post', description: 'Fun things going on.') }

  it 'does not show Edit button to other users' do
    post.comments.create( {:content => 'This is beans!!!'})
    comment = Comment.last

    visit post_path(post)
    expect(page).to have_content('Good Post')
    expect(page).to have_content(comment.content)

    expect(page).to_not have_css('.comment-edit')
  end

  it 'allows comment user to edit' do
    post.comments.create( {:content => 'This is fun!!!'})

    comment = Comment.last
    comment.user = user
    comment.save

    sign_in user, password: 'beans'

    visit post_path(post)
    expect(page).to have_content('Good Post')

    find('.comment-edit').click
    find("#comment_#{comment.id}_content").set('This is funny!!!')
    find('#update_comment_' + comment.id.to_s).click

    expect(page).to have_content('Good Post')

    comment.reload
    expect(page).to have_content(comment.content)
  end

  it 'will upload a pic' do
    post.comments.create( {:content => 'This is fun!!!'})

    comment = Comment.last
    comment.user = user
    comment.save

    sign_in user, password: 'beans'

    visit post_path(post)
    expect(page).to have_content('Good Post')

    find('.comment-edit').click
    find("#comment_#{comment.id}_content").set('This is funny!!!')
    attach_file("comment_#{comment.id}_photo", Rails.root.join('app/assets/images/test_avatar.jpg'))
    find("#update_comment_#{comment.id}").click

    expect(page).to have_content('Good Post')

    comment.reload
    expect(page).to have_content(comment.content)
  end
end