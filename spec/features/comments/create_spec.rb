require 'rails_helper'

describe 'Creating comments' do
  let(:user) { create(:user) }
  let(:post) { Post.create(title: 'Good Post', description: 'Fun things going on.') }

  it 'redirects to the post on success' do
    visit post_path(post)
    expect(page).to have_content('Good Post')

    find('.comment-button').click
    find('#comment_content').set('This is fun!!!')
    click_button 'Save Comment'

    expect(post.comments.count).to eq(1)
    expect(page).to have_content('Good Post')

    comment = Comment.last
    expect(page).to have_content(comment.content)
  end

  it 'adds the user to the comment if logged in' do
    sign_in user, password: 'beans'

    visit post_path(post)
    expect(page).to have_content('Good Post')

    find('.comment-button').click
    find('#comment_content').set('This is fun!!!')
    click_button 'Save Comment'

    expect(post.comments.count).to eq(1)
    expect(page).to have_content('Good Post')

    comment = Comment.last
    expect(page).to have_content(comment.content)
    expect(comment.user).to eq(user)
  end

  it 'can upload a pic' do
    sign_in user, password: 'beans'

    visit post_path(post)
    expect(page).to have_content('Good Post')

    find('.comment-button').click
    find('#comment_content').set('This is fun!!!')
    attach_file('comment[photo]', Rails.root.join('app/assets/images/test_avatar.jpg'))
    click_button 'Save Comment'

    expect(post.comments.count).to eq(1)
    expect(page).to have_content('Good Post')
  end

  it 'can comment on a comment', :js => true do
    sign_in user, password: 'beans'

    visit post_path(post)
    expect(page).to have_content('Good Post')

    find('.comment-button').click
    find('#comment_content').set('This is fun!!!')
    click_button 'Save Comment'

    expect(post.comments.count).to eq(1)
    expect(page).to have_content('Good Post')

    comment = Comment.last
    expect(page).to have_content(comment.content)
    find('.comment-add').click # Reply? button
    find("#content_comment_#{comment.id}").set('This is more Comment fun...')

    find("#save_comment_#{comment.id}" ).click

    expect(comment.children.count).to eq(1)
    expect(page).to have_content('Good Post')

    comment_comment = Comment.last
    expect(page).to have_content(comment_comment.content)
  end

  it 'can comment as an organization', :js => true do
    sign_in user, password: 'beans'
    create_organization
    organization = Organization.last

    visit post_path(post)
    expect(page).to have_content('Good Post')

    find('.comment-button').click
    find('#comment_content').set('This is fun!!!')
    find('#post_organization').find(:xpath, 'option[2]').select_option

    click_button 'Save Comment'

    expect(post.comments.count).to eq(1)
    expect(page).to have_content('Good Post')
    expect(page).to have_content('by BCN')

    comment = Comment.last
    expect(page).to have_content(comment.content)
    expect(comment.organization.name).to eq(organization.name)
  end
end