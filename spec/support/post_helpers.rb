module PostHelpers
  def create_post(options={})
    options[:title] ||= 'My Post'
    options[:description] ||= 'Great new post.'

    visit '/posts'
    click_link 'New Post'
    expect(page).to have_content('New Post')

    fill_in 'Title', with: options[:title]
    fill_in 'Description', with: options[:description]
    click_button 'Save Post'

    return Post.last
  end

  def update_post(options={})
    options[:title] ||= 'My Post'
    options[:description] ||= 'Great new post.'

    post = options[:post]

    visit '/posts'

    within "#post_#{post.id}" do
      click_link 'Edit'
    end

    fill_in 'Title', with: options[:title]
    fill_in 'Description', with: options[:description]
    click_button 'Save Post'
  end
end