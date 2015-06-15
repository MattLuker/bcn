require 'rails_helper'

describe "Viewing locations" do
  let!(:post) { Post.create(title: "Location Post", description: "Great job location!") }

  it "displays the title of the post" do
    visit('/posts/' + post.id.to_s)
    expect(page).to have_content(post.title)
  end

  it "displays no items when locations is empty" do
    visit('/posts/' + post.id.to_s)

    expect(page.all('span#page_' + post.id.to_s)).to have_content('')
  end

  it "dipslays location content when a post has a location" do 
    location = Location.new.create(lat: 36.21991, lon: -81.68261)
    post.locations << location

    visit('/posts/' + post.id.to_s)
    click_link 'Locations'

    expect(page).to have_content('Watauga County Public Library')
  end


  before do
    for i in 1..3
      Location.create(
          lat: 36.21640465,
          lon: -81.6822302793054,
          name: 'Kenneth E. Peacock Hall',
          address: '416 Howard Street',
          city: 'Boone',
          state: 'North Carolina',
          postcode: '28607',
          county: 'Watauga',
          country: 'us'
      )
      location = Location.last

      Post.create(title: "Location API Post #{i}", description: "Number #{i} post.", locations: [location])
    end
  end

  it 'displays a list of posts based on a location', :js => true do
      visit '/home'
      find('#map').click
      find('#map').click
      sleep(1)
      find('#posts_here').click
      expect(page).to have_content('Posts For: Kenneth E. Peacock Hall')
  end
end
