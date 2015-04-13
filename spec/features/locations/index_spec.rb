require 'rails_helper'

describe "Viewing locations" do 
  let!(:post) { Post.create(title: "Location Post", description: "Great job location!") }

  it "displays the title of the post" do 
    visit_post(post)
    within("h1") do
      expect(page).to have_content(post.title)
    end 
  end

  it "displays no items when locations is empty" do
    visit_post(post)
    expect(page.all("ul.locations li").size).to eq(0)
  end

  it "dipslays location content when a post has a location" do 
    location = Location.create(lat: 36.21991, lon: -81.68261)
    post.location = location
    visit_post(post)
    expect(page.all("ul.location li").size).to eq(1)

    within "ul.location" do
      #expect(page).to have_content("Watagau County Public Library")
      expect(page).to have_content("latitude: #{post.location.lat}, longitude: #{post.location.lon}")
    end
  end
end
