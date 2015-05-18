require 'rails_helper'

describe 'Forgotten passwords' do
  let!(:user) {create(:user)}

  it 'sends a user an email' do
    visit login_path
    click_link 'Forgot Password?'
    fill_in 'Email', with: user.email

    expect {
      click_button 'Reset Password'
    }.to change{ ActionMailer::Base.deliveries.size }.by(1)
  end
end