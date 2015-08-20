module CommunityHelpers
  def create_community
    visit('/communities/new')

    fill_in 'Name', with: 'Boone Community Network'
    page.execute_script("window.desc_editor.codemirror.setValue('We are all part of the Boone community!')")
    find('#community_home_page').set('http://boonecommunitynetwork.com')
    fill_in 'Color', with: '#000000'
    attach_file('community[image]', Rails.root.join('app/assets/images/test_avatar.jpg'))

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
    #page.driver.browser.navigate.refresh
  end

  def create_organization
    #
    # I know this shouldn't go here, but it feels good...
    #
    visit('/organizations/new')

    fill_in 'Name', with: 'BCN'
    page.execute_script("window.desc_editor.codemirror.setValue('BCN Rulez!')")
    find('#organization_web_url').set('http://boonecommunitynetwork.com')
    fill_in 'Color', with: '#222222'
    click_button 'Save Organization'

  end
end