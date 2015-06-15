module CommunityHelpers
  def create_community
    visit('/communities/new')

    fill_in 'Name', with: 'Boone Community Network'
    fill_in 'Description', with: "We're all part of the Boone community!"
    find('#community_home_page').set('http://boonecommunitynetwork.com')
    fill_in 'Color', with: '#000000'
    click_button 'Save Community'
  end
end