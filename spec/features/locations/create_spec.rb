require 'rails_helper'

describe 'Adding locations' do
  #Kenneth E. Peacock Hall, 416, Howard Street, Boone, Watauga County, North Carolina, 28608,
  # United States of America (university) 36.21640465, -81.6822303793054

  let!(:post) { Post.create(title: 'Location Post', description: 'Great job location!') }
  let!(:location) { Location.new.create(
      lat: 36.21640465,
      lon: -81.6822303793054,
      post_id: 1,
      name: 'Kenneth E. Peacock Hall',
      address: '416 Howard Street',
      city: 'Boone',
      state: 'NC',
      county: 'Watauga',
      country: 'us') }

  it 'is successful with valid content and correct log entry', :js => true do
    create_post_with_location

    expect(page).to have_content('Location: Kenneth E. Peacock Hall')

    logs = Log.last(2)

    expect(logs[0].location).to eq(Location.last)
    expect(logs[0].action).to eq('created')
  end

  it 'is successful when adding a location to a post without a location', :js => true do
    visit('/posts/new')

    fill_in 'Title', with: 'My Non-Location Post'
    fill_in 'Description', with: 'Great new post Non-Located.'
    click_button 'Save Post'

    expect(page).to have_content('Post was successfully created.')

    find('#map').click
    expect(page).to have_content('Location Set to: Kenneth E. Peacock Hall')

    expect(page).to have_content('Location: Kenneth E. Peacock Hall')

  end
end
