
require 'rails_helper'

describe 'Deleting comments' do
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

  it 'allows comment user to delete', :js => true do
    post.comments.create( {:content => 'This is fun!!!'})

    comment = Comment.last
    comment.user = user
    comment.save

    sign_in user, password: 'beans'

    visit post_path(post)
    expect(page).to have_content('Good Post')

    click_button 'Edit'
    find("#comment_#{comment.id}_delete").click
    sleep(0.5)
    click_button 'Ok'

    expect(page).to have_content('Comment deleted.')
    expect(page).to_not have_content(comment.content)
  end

  it 'allows admin to delete', :js => true do
    post.comments.create( {:content => 'This is fun!!!'})
    admin = User.create({ :email => 'bill@thehoick.com', :password => 'beans', :role => 'admin' })


    comment = Comment.last
    comment.user = user
    comment.save

    sign_in admin, password: 'beans'

    visit post_path(post)
    expect(page).to have_content('Good Post')

    click_button 'Edit'
    find("#comment_#{comment.id}_delete").click
    sleep(0.5)
    click_button 'Ok'

    expect(page).to have_content('Comment deleted.')
    expect(page).to_not have_content(comment.content)
  end
end