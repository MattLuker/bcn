#require 'spec_helper'
require 'rails_helper'

describe "Creating posts" do

  it "redirects to the post list index page on success" do
    create_post
    expect(page).to have_content("My Post")
  end

  it "success from creating a post by clicking on the map then the New Post popup link", :js => true do
    visit "/home"
    find("#map").click

    expect(page).to have_content("New Post")
    find("#new_post").click

    fill_in "Title", with: "My Location Post"
    fill_in "Description", with: "Great new post."
    click_button "Save Post"
    expect(page).to have_content("My Location Post")
  end

  it "displays an error when the Post has no title" do
    expect(Post.count).to eq(0)

    create_post title: ""

    expect(page).to have_content("error")
    expect(Post.count).to eq(0)

    visit "/posts"
    expect(page).to_not have_content("Great new post.")

  end

  it "displays an error when the Post has no description" do
    expect(Post.count).to eq(0)

    create_post description: ""

    expect(page).to have_content("error")
    expect(Post.count).to eq(0)

    visit "/posts"
    expect(page).to_not have_content("Great new post.")

  end

  it "success when creating a post with a community" do
    create_community
    expect(page).to have_content('Community was successfully created.')

    visit "/posts"
    click_link "New Post"
    expect(page).to have_content("New Post")

    fill_in "Title", with: "My Location Post"
    fill_in "Description", with: "Great new post."

    within("div.communities") do
      select 'Boone Community Network'
    end

    click_button "Save Post"


    expect(page).to have_content("Description: Great new post.")
  end

  it 'has a log entry after creation' do
    create_post
    log = Log.last

    expect(log.post).to eq(Post.last)
    expect(log.action).to eq("created")
  end

  it 'creates a post for the current user' do
    user = create(:user)
    sign_in(user, {password: 'beans'})
    create_post

    expect(Post.last.user).to eq(user)
  end
end
