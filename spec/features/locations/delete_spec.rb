require 'rails_helper'

describe 'Editing locations' do
  let(:user) { create(:user) }

  it 'is successful and has been logically deleted', :js => true do
    sign_in user, password: 'beans'

    create_post_with_location

    click_link 'Locations'
    find('.remove_location').click
    #page.driver.browser.switch_to.alert.accept
    sleep(1)
    click_button 'Ok'

    post = Post.where(title: 'My Location Post').first

    expect(page).to have_content('Location was deleted.')
    expect(page).to have_content(post.description)

    del_location = Location.only_deleted.last

    expect(del_location.deleted?).to eq(true)
    expect(del_location.deleted_at).to_not eq(nil)
  end
end
