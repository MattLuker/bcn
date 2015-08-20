module UserHelpers
  def create_user
    visit '/'

    expect(page).to have_content('Register')
    click_link 'Register'

    fill_in 'Email', with: 'adam@thehoick.com'
    fill_in 'Password', with: 'beans'
    click_button 'Register'
  end


  def create_badge
    admin = User.create({ :email => 'blane@thehoick.com', :password => 'beans' })
    Role.create(user: admin, name: 'admin')
    sign_in admin, password: 'beans'

    visit '/badges/new'

    find('#badge_name').set('Comment Beginner')
    find('#badge_description').set('Commented more then 5 Times!')
    find('#badge_rules').set('user.comments.count > 0')

    attach_file('badge[image]', Rails.root.join('app/assets/images/five_icon.svg'))

    click_button 'Save Badge'

    expect(Badge.all.count).to eq(1)
    expect(page).to have_content("Comment Beginner")
  end
end