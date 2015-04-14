require 'rails_helper'

describe "Viewing locations" do
  let!(:post) { Post.create(title: "Location Post", description: "Great job location!") }

  it "displays the title of the post" do
    visit('/posts/' + post.id.to_s)
    expect(page).to have_content('Title: ' + post.title)
  end

  it "displays no items when locations is empty" do
    visit('/posts/' + post.id.to_s)

    expect(page.all('span#page_' + post.id.to_s)).to have_content('')
  end

  it "dipslays location content when a post has a location" do 
    location = Location.new.create(lat: 36.21991, lon: -81.68261)
    post.location = location

    visit('/posts/' + post.id.to_s)

    expect(page).to have_content('Location: Watauga County Public Library')
  end
end
