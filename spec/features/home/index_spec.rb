require 'rails_helper'

describe "Creating posts" do
  let(:user) { create(:user) }
  let!(:new_post) { Post.create(title: 'Location Post', description: 'Great job location!') }
  let(:bcn) { Community.create(name: 'BCN', description: 'Boone Rulez!')}
  let(:music) { Community.create(name: 'Music', description: 'Music Rulez!')}
  let!(:location) { Location.new.create(
      lat: 36.21640465,
      lon: -81.6822303793054,
      name: 'Kenneth E. Peacock Hall',
      address: '416 Howard Street',
      city: 'Boone',
      state: 'NC',
      county: 'Watauga',
      country: 'us') }
  let!(:loc) { Location.new.create(
      lat: 36.21640465,
      lon: -81.6822303793054,
      name: 'Kenneth E. Peacock Hall',
      post_id: 4,
      address: '416 Howard Street',
      city: 'Boone',
      state: 'NC',
      county: 'Watauga',
      country: 'us') }
  let!(:today_post) { Post.create(title: 'Today Post',
                                description: 'Great job Today!',
                                start_date: Date.today.strftime('%Y-%m-%d'),
                                communities: [bcn],
                                locations: [loc]
  ) }
  let!(:tomorrow_post) { Post.create(title: 'Tomorrow Post',
                                  description: 'Great job Tomorrow!',
                                  start_date: (Date.today + 1).strftime('%Y-%m-%d'),
                                  communities: [bcn]

  ) }
  let!(:next_week_post) { Post.create(title: 'Next Week Post',
                                  description: 'Great job Next week!',
                                  start_date: (Date.today + 7).strftime('%Y-%m-%d'),
                                  communities: [music],
                                  locations: [location]
  ) }
  let!(:new_post) { Post.create(title: 'Nice Things', description: 'Great job location!', communities: [music]) }
  let!(:new_post) { Post.create(title: 'Beans Post', description: 'Great job location!', communities: [bcn]) }


  it  'filters posts for today when today button is pressed', :js => true do
    visit '/'

    find('.today').click
    expect(page).to have_content('Today Post')
    expect(page).to_not have_content('Location Post')
  end

  it  'filters posts for tomorrow when tomorrow button is pressed', :js => true do
    visit '/'

    find('.tomorrow').click
    expect(page).to have_content('Tomorrow Post')
    expect(page).to_not have_content('Location Post')
    expect(page).to_not have_content('Today Post')
  end

  it  'filters posts for next week when next week button is pressed', :js => true do
    visit '/'

    find('.next_week').click
    sleep(0.3)

    expect(page).to have_content('Next Week Post')
    expect(page).to_not have_content('Location Post')
    expect(page).to_not have_content('Today Post')
    expect(page).to_not have_content('Tomorrow Post')
  end

  it 'filters posts based on communities', :js => true do
    pending 'works when run by itself... not sure why it does not play well with the group.'
    visit '/'

    #find('#all_communities').click
    sleep(1)
    #click_button 'Music'
    find('.community_1').click

    expect(page).to have_content('Nice Things')
    expect(page).to_not have_content('Location Post')
    expect(page).to_not have_content('Beans Post')
  end

  it 'filters based on location search', :js => true do
    visit '/'

    fill_in 'Name', with: 'Kenneth Peacock Hall'
    find('.loc-search-button').click

    expect(page).to have_content('Today Post')
    expect(page).to have_content('Next Week Post')
    expect(page).to_not have_content('Location Post')
  end

  it 'displays upcoming posts when the tab is clicked', :js => true do
    visit '/'

    find('#events-tab').click

    expect(page).to have_content('Today Post')
    expect(page).to have_content('Tomorrow Post')
    expect(page).to have_content('Next Week Post')
  end

end
