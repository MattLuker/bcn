require 'rails_helper'

describe 'Deleting posts' do

  context 'authenticated' do
    let!(:user) { create(:user) }
    before do
      sign_in(user, {password: 'beans'})
    end
    let!(:post) { Post.create(title: 'Great Post', description: 'Great job!', user_id: user.id) }

    it 'is successful when clicking the destroy link', :js => true do
      visit "/posts"

      click_link 'Great Post'
      find('.post-edit').click

      click_link 'Delete'
      sleep(0.3)
      click_button 'Ok'

      expect(page).to_not have_content(post.title)
      expect(Post.count).to eq(0)
    end

    it "is successful when clicking the destroy link and it is logically deleted", :js => true do
      visit "/posts"

      click_link 'Great Post'
      find('.post-edit').click

      click_link 'Delete'
      sleep(0.3)
      click_button 'Ok'

      expect(page).to_not have_content(post.title)
      expect(Post.count).to eq(0)

      del_post = Post.only_deleted.last

      expect(del_post.deleted?).to eq(true)
      expect(del_post.deleted_at).to_not eq(nil)
    end

    it 'decrements the community posts_counter when destroyed', :js => true do
      create_community
      community = Community.last
      expect(page).to have_content('Community was successfully created.')

      visit '/posts'
      click_link 'New Post'
      expect(page).to have_content('New Post')

      fill_in 'Title', with: 'My Location Post'
      fill_in "What's on your mind?", with: 'Great new post.'

      fill_in 'Communities (in a comma separated list)', with: 'Boone Community Network'
      click_button 'Save Post'

      community.reload
      expect(page).to have_content('Great new post.')
      expect(community.posts_count).to eq(1)

      find('.post-edit').click

      click_link 'Delete'
      sleep(0.3)
      click_button 'Ok'
      sleep(0.3)

      community.reload
      expect(community.posts_count).to eq(0)
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
