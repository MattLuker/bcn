module AuthenticationHelpers
  def sign_in(user, options={})
    # controller.stub(:current_user).and_return(user)
    # controller.stub(:user_id).and_return(user.id)

    visit '/login'
    sleep(0.3)
    fill_in 'Email', with: user.email
    fill_in 'Password', with: options[:password]
    click_button 'Log In'
  end

  def sign_out
    visit '/logout'
  end
end