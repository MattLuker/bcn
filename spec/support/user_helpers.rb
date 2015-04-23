module UserHelpers
  def create_user
    visit '/'

    expect(page).to have_content('Register')
    click_link 'Register'

    fill_in 'Email', with: 'adam@thehoick.com'
    fill_in 'Password', with: 'beans'
    click_button 'Register'
  end
end