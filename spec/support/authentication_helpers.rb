module AuthenticationHelpers
  def sign_in(user, options={})
    # controller.stub(:current_user).and_return(user)
    # controller.stub(:user_id).and_return(user.id)

    visit '/login'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: options[:password]
    click_button 'Log In'
  end

  def valid_facebook_login_setup
    if Rails.env.test?
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
                                                                        provider: 'facebook',
                                                                        uid: '105655459769118',
                                                                        info: {
                                                                            first_name: "Linda",
                                                                            last_name:  "Carrieroberg",
                                                                            email:      "ijvebzx_carrieroberg_1431943596@tfbnw.net"
                                                                        },
                                                                        credentials: {
                                                                            token: "123456",
                                                                            expires_at: Time.now + 1.week
                                                                        },
                                                                        extra: {
                                                                            raw_info: {
                                                                                gender: 'female'
                                                                            }
                                                                        }
                                                                    })
    end
  end
end