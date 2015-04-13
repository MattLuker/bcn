require 'rails_helper'

describe "Editing posts" do 

  let!(:post) { Post.create(title: "Great Post", description: "Great job!") }

  def update_post(options={})
    options[:title] ||= "My Post"
    options[:description] ||= "Great new post."

    post = options[:post]

    visit "/posts"

    within "#post_#{post.id}" do 
      click_link "Edit"
    end

    fill_in "Title", with: options[:title]
    fill_in "Description", with: options[:description]
    click_button "Save Post"
  end

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
