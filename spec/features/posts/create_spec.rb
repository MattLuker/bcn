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
    # start_date = DateTime.now
    # end_date = DateTime.now + 1.hour

    user = create(:user)
    sign_in(user, {password: 'beans'})

    visit '/posts'
    click_link 'New Post'
    expect(page).to have_content('New Post')

    fill_in 'Title', with: 'Event Post'
    fill_in 'Description', with: 'This is a great event!'
    fill_in 'Start date', with: '2015-05-25'
    fill_in 'post[start_time]', with: '05:05'
    fill_in 'End date', with: '2015-05-25'
    fill_in 'post[end_time]', with: '06:05'
    click_button 'Save Post'
    post = Post.last

    expect(post.start_date).to eq(Date.parse('2015-05-25'))
    expect(post.end_date).to eq(Date.parse('2015-05-25'))
    expect((post.start_time).to_s(:time)).to eq('05:05')
    expect((post.end_time).to_s(:time)).to eq('06:05')
  end

  it 'creates a post with a event date selected using the javascript helpers', :js => true do
    user = create(:user)
    sign_in(user, {password: 'beans'})

    visit '/home'
    find('#map').click

    expect(page).to have_content('New Post')
    find('#new_post').click

    fill_in 'Title', with: 'My Location Post'
    fill_in "Description", with: 'Great new post.'

    find(:css, '#event').set(true)
    find(:css, '#post_start_date').click
    first('.day').click

    find(:css, '#post_start_time').click
    first('.clockpicker-tick').click
    first('.clockpicker-minutes .clockpicker-tick').click

    find(:css, '#post_end_date').click
    first('.day').click

    find(:css, '#post_end_time').click
    first('.clockpicker-tick').click
    first('.clockpicker-minutes .clockpicker-tick').click

    click_button 'Save Post'
    expect(page).to have_content("My Location Post")
  end
end
