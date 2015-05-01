require 'rails_helper'

describe "Creating posts" do
  let(:user) { create(:user) }

  it "redirects to the post list index page on success" do
    create_post
    expect(page).to have_content("My Post")
  end

  it "succeeds when creating a post by clicking on the map then the New Post popup link", :js => true do
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
    sign_in user, password: 'beans'
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

  it 'creates a post with many locations', :js => true do
    user = create(:user)
    sign_in(user, {password: 'beans'})

    visit "/home"
    find("#map").click

    expect(page).to have_content("New Post")
    find("#new_post").click

    fill_in "Title", with: "My Location Post"
    fill_in "Description", with: "Great new post."
    click_button "Save Post"
    expect(page).to have_content("My Location Post")
    post = Post.last

    # visit "/home"
    find("#map").click
    #
    expect(page).to have_content("Add Location")
    find("#new_location").click
    sleep(1)
    expect(post.locations.count).to eq(2)
  end

  it 'creates a post with as an event' do
    start_date = DateTime.now
    end_date = DateTime.now + 1.hour

    user = create(:user)
    sign_in(user, {password: 'beans'})

    visit '/posts'
    click_link 'New Post'
    expect(page).to have_content('New Post')

    fill_in 'Title', with: 'Event Post'
    fill_in 'Description', with: 'This is a great event!'
    fill_in 'Start date', with: '5/25/2015 05:05:05'
    fill_in 'End date', with: '5/25/2015 06:05:05'
    click_button 'Save Post'
    post = Post.last

    expect(post.start_date).to eq(DateTime.strptime('5/25/2015 05:05:05', '%m/%d/%Y %I:%M:%S'))
    expect(post.end_date).to eq(DateTime.strptime('5/25/2015 06:05:05', '%m/%d/%Y %I:%M:%S'))
  end
end
