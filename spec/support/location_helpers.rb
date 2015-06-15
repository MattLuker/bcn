module LocationHelpers
  def visit_post(post)
    visit '/posts'

    within dom_id_for(post) do
      click_link 'List Locations'
    end
  end

  def create_post_with_location
    visit '/home'
    find('#map').click
    find('#map').click
    find('#new_post').click

    fill_in 'Title', with: 'My Location Post'
    fill_in "What's on your mind?", with: 'Great new post.'
    click_button 'Save Post'
  end
end
