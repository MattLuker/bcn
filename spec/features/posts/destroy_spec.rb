require 'rails_helper'

describe "Deleting posts" do 
  let!(:post) { Post.create(title: "Great Post", description: "Great job!") }

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
