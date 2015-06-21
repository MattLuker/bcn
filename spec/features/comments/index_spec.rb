require 'rails_helper'

describe 'Shwoing comments' do
  let(:user) { create(:user) }
  let(:post) { Post.create(title: 'Good Post', description: 'Fun things going on.') }
  let(:comment) { Comment.create(content: 'Fun Comment #1', post_id: post.id) }

  it 'it shows the comment' do
    visit '/comments/' + comment.id.to_s

    expect(page).to have_content('Fun Comment #1')
  end
end