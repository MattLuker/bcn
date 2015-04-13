require 'rails_helper'

describe 'Editing locations' do

  it 'is successful and has been logically deleted', :js => true do
    create_post_with_location

    click_link 'Remove Location'
    page.driver.browser.switch_to.alert.accept

    post = Post.where(title: 'My Location Post').first

    expect(page).to have_content('Location was deleted.')
    expect(page).to have_content("Description: #{post.description}")

    del_location = Location.only_deleted.last

    expect(del_location.deleted?).to eq(true)
    expect(del_location.deleted_at).to_not eq(nil)
  end
end
