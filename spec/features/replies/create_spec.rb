require 'rails_helper'

describe 'Create replies' do
  let(:user) { create(:user) }
  let(:post) { Post.create(title: 'Good Post', description: 'Fun things going on.') }
  #let(:comment) { Comment.create(content: 'Great comment!', post_id: post.id, user_id: user.id) }

  it 'successfully creates a reply on comment' do
    visit post_path(post)
    expect(page).to have_content('Good Post')

    click_button 'Comment?'
    find('#comment_content').set('Great comment!')
    click_button 'Save Comment'
    expect(page).to have_content('Great comment!')

    #find("#comment_#{comment.id}_reply").click
    click_button 'Reply?'

    find('#reply_content').set('Fun reply...')
    click_button 'Save Reply'

    reply = Reply.last
    expect(page).to have_content(reply.content)
  end
end