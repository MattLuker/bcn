require 'rails_helper'

describe "Searches index" do
  let!(:post1) { Post.create(title: 'Location Event', description: 'Great job location!') }
  let!(:post2) { Post.create(title: '2nd Event', description: 'Great job beans!') }
  let!(:post3) { Post.create(title: '3 Thing', description: 'Doing things tdd...') }

  let!(:comment1) { Comment.create(content: 'Comment on 1st.', post: post1)}
  let!(:comment2) { Comment.create(content: 'Comment on 1st comment...', parent_id: comment1.id)}

  it 'returns one post on pressing the search button', :js => true do
    visit '/'

    fill_in 'Search the Booniverse', with: 'location'
    find('#search_button').click

    expect(page).to have_content('Location Event')
    expect(page).to have_content('Found 1 results')
  end

  it 'returns one post on pressing enter', :js => true, :visual => true, :firefox => true do
    visit '/'

    fill_in 'Find happiness', with: 'location'
    find('#search_query').native.send_keys(:return)

    expect(page).to have_content('Location Event')
    expect(page).to have_content('Found 1 results')
  end

  it 'returns two posts on pressing enter', :js => true, :visual => true, :firefox => true  do
    visit '/'

    fill_in 'Search the Booniverse', with: 'Event'
    find('#search_query').native.send_keys(:return)

    expect(page).to have_content('Location Event')
    expect(page).to have_content('2nd Event')
    expect(page).to have_content('Found 2 results')
  end

  it 'returns two comments on pressing enter', :js => true, :visual => true, :firefox => true  do
    visit '/'

    fill_in 'Search the Booniverse', with: 'Comment'
    find('#search_query').native.send_keys(:return)

    expect(page).to have_content('Comment on 1st.')
    expect(page).to have_content('Comment on 1st comment...')
    expect(page).to have_content('Found 2 results')
  end
end