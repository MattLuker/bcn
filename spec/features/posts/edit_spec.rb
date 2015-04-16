require 'rails_helper'

describe "Editing posts" do

  context 'authenticated' do
    let!(:user) { create(:user) }
    before do
      sign_in(user, {password: 'beans'})
    end
    let!(:post) { Post.create(title: "Great Post", description: "Great job!", user_id: user.id) }

    it "upates a post successfully with correct information" do
      update_post(title: "Great New Title", description: "Great New Job! and stuff...", post: post)

      post.reload

      expect(page).to have_content("Post was successfully updated")
      expect(post.title).to eq("Great New Title")
      expect(post.description).to eq("Great New Job! and stuff...")
    end

    it "displays an error if no title" do
      update_post(title: "", description: "Great New Job! and stuff...", post: post)
      expect(page).to have_content("error")
    end

    it "displays an error if no description" do
      update_post(title: "Great New Title", description: "", post: post)
      expect(page).to have_content("error")
    end

    it 'has a log entry after creation' do
      update_post(title: "Great New Title", description: "Great New Job! and stuff...", post: post)

      post.reload

      log = Log.last

      expect(log.post).to eq(Post.last)
      expect(log.action).to eq("updated")
    end
  end

  context 'authenticated non-post user' do
    let!(:post) { Post.create(title: "Great Post", description: "Great job!") }

    it 'will not let non-post user edit post' do
      user = User.create({email: 'bob@thehoick.com', password: 'beans'})
      sign_in(user, {password: 'beans'})

      update_post(title: "Great New Title", description: "Great New Job! and stuff...", post: post)
      expect(page).to have_content('You can only update your posts.')
    end
  end

  context 'unauthenticated' do
    it 'does not allow non-post user to edit post' do
      create_post
      visit "/posts/#{Post.last.id}/edit"

      expect(page).to have_content('You must be logged in to update a post.')
      expect(find_button('Log In').value).to eq('Log In')
    end
  end
end
