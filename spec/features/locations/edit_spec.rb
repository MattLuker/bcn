require 'rails_helper'

describe "Editing locations" do


  # it "is successful with valid content", :js => true do
  #   create_post_with_location
  #   expect(page).to have_content("Location: Kenneth E. Peacock Hall")
  # end

  it "changes the location when marker moved", :js => true do
    pending "Until drag and drop works, but make sure the API works."
    # create_post_with_location
    # expect(page).to have_content("Location: Kenneth E. Peacock Hall")
    # post = Post.where(title: "My Location Post").first
    #
    # drop_element = page.all(:css, 'img.leaflet-tile.leaflet-tile-loaded')[2]
    # #puts "drop_element #{drop_element}"
    #
    # #marker = page.first('img.leaflet-marker-icon')
    # marker = page.first('img.leaflet-marker-draggable')
    # #puts "marker: #{marker}"
    # #marker.click
    # #sleep(4)
    # #all('.leaflet-marker-icon').drag_to drop_element
    # #marker.drag_by(10, 5)
    # #driver = page.driver.browser
    # #driver.action.drag_and_drop_by(marker.native, 4, 5).perform
    # #driver.action.click_and_hold(marker.native).perform
    # #driver.action.drag_and_drop_by(marker.native, 40, 15).perform
    # #driver.action.release.perform
    # #driver.action.move_to(drop_element.native).perform
    # #driver.action.drag_and_drop(marker.native, drop_element.native).perform
    # #marker.drag_to drop_element
    # marker.drag_to find("#post_" + post.id.to_s)
    # sleep(8)
    #
    # expect(page).to have_content("Location updated to:")
    #
    expect(post.location.name).to_not eq("Kenneth E. Peacock Hall")
  end
end
