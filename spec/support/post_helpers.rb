module PostHelpers
  def create_post(options={})
    options[:title] ||= 'My Post'
    options[:description] ||= 'Great new post.'

    visit '/posts'
    click_link 'New Post'
    expect(page).to have_content('New Post')

    fill_in 'Title', with: options[:title]
    #fill_in "What's happening?", with: options[:description]
    page.execute_script("window.post_editor.codemirror.setValue('#{options[:description]}')")
    click_button 'Save Post'

    return Post.last
  end

  def update_post(options={})
    options[:title] ||= 'My Post'
    options[:description] ||= 'Great new post.'

    post = options[:post]

    visit '/posts'
    click_link options[:post].title
    find('.post-edit').click

    fill_in 'Title', with: options[:title]
    fill_in "What's happening?", with: options[:description]
    fill_in 'post[start_date]', with: options[:start_date] if options[:start_date]
    fill_in 'post[end_date]', with: options[:end_date] if options[:end_date]
    fill_in 'post[start_time]', with: options[:start_time] if options[:start_time]
    fill_in 'post[end_time]', with: options[:end_time] if options[:end_time]

    click_button 'Save Post'
  end
end