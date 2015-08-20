require 'rails_helper'

describe "Creating badges" do
  let(:user) { create(:user) }

  it 'does not allow non-admin users to create badges' do
    sign_in user, password: 'beans'
    visit '/badges/new'

    expect(page).to have_content('Page not available.')
  end

  context 'admin' do
    before do
      admin = User.create({ :email => 'blane@thehoick.com', :password => 'beans' })
      Role.create(user: admin, name: 'admin')
      sign_in admin, password: 'beans'
    end

    it "redirects to the badge show page on success" do
      visit '/badges/new'

      find('#badge_name').set('Comment Beginner')
      find('#badge_description').set('Commented more then 5 Times!')
      find('#badge_rules').set('user.comments.count > 5')

      attach_file('badge[image]', Rails.root.join('app/assets/images/five_icon.svg'))

      click_button 'Save Badge'

      expect(Badge.all.count).to eq(1)
      expect(page).to have_content("Comment Beginner")
    end
  end
end