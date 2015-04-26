require 'rails_helper'

describe "Deleting posts" do

  context 'authenticated' do
    let!(:user) { create(:user) }
    before do
      sign_in(user, {password: 'beans'})
    end
    let!(:post) { Post.create(title: "Great Post", description: "Great job!", user_id: user.id) }

    it "is successful when clicking the destroy link" do
      visit "/posts"

      within "#post_#{post.id}" do
        click_link "Destroy"
      end

      expect(page).to_not have_content(post.title)
      expect(Post.count).to eq(0)
    end

    it "is successful when clicking the destroy link and it is logically deleted" do
      visit "/posts"

      within "#post_#{post.id}" do
        click_link "Destroy"
      end

      expect(page).to_not have_content(post.title)
      expect(Post.count).to eq(0)

      del_post = Post.only_deleted.last

      expect(del_post.deleted?).to eq(true)
      expect(del_post.deleted_at).to_not eq(nil)
    end
  end

  context 'unauthenticated' do
    it 'does not allow non-post user to destroy post' do
      create_post
      visit "/posts/#{Post.last.id}/edit"

      expect(page).to have_content('You must be logged in to view that page.')
      expect(find_button('Log In').value).to eq('Log In')
    end
  end
end
