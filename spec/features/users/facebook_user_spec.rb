require 'rails_helper'

describe 'Signing Up with Facebook' do
  # before(:each) do
  #   valid_facebook_login_setup
  #   visit "auth/facebook/callback"
  #   request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  # end
  #
  # it "should set user_id" do
  #   expect(session[:user_id]).to eq(User.last.id)
  # end
  #
  # it "should redirect to root" do
  #   expect(response).to redirect_to home_path
  # end

  it 'allows user to sign up via Facebook', :js => true do
    expect(User.count).to eq(0)

    visit '/'

    expect(page).to have_content('Register')
    click_link 'Register'
    click_link 'Register with Facebook'

    expect(page).to have_content('Facebook Login')

    fill_in 'Email or Phone:', with: FACEBOOK_CONFIG['username']
    fill_in 'Password:', with: FACEBOOK_CONFIG['password']
    #sleep(10)
    find('#u_0_2').click # 'Log In' button element.
    sleep 5

    expect(User.count).to eq(1)
    expect(page).to have_content("Welcome #{FACEBOOK_CONFIG['first_name']}, you have been registered using Facebook.")
  end
end