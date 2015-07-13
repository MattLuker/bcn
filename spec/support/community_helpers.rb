module CommunityHelpers
  def create_community
    visit('/communities/new')

    fill_in 'Name', with: 'Boone Community Network'
    #fill_in 'Description', with: "We're all part of the Boone community!"
    page.execute_script("window.desc_editor.codemirror.setValue('We are all part of the Boone community!')")
    find('#community_home_page').set('http://boonecommunitynetwork.com')
    fill_in 'Color', with: '#000000'
    click_button 'Save Community'
  end

  def create_community_js
    visit('/communities/new')

    fill_in 'Name', with: 'Boone Community Network'
    find('#community_home_page').set('http://boonecommunitynetwork.com')
    fill_in 'Color', with: '#000000'
    click_button 'Save Community'

    # Until there's a better way to set text with Selenium on the Lepture Editor...
    community = Community.last
    community.description = "We're all part of the Boone community!"
    community.save
    page.driver.browser.navigate.refresh
  end
end