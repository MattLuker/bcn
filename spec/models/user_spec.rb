require 'rails_helper'

RSpec.describe User, type: :model do
  let(:valid_attributes) {
    {
        username: 'adam',
        email: 'adam@thehoick.com',
        password: 'beans',
        password_confirmation: 'beans'
    }
  }

  context 'relationships' do
    it { should have_many :posts }
    it { should have_many :comments }
    it { should have_many :subscriptions }
    it { should have_many :facebook_subscriptions }
    it { should have_and_belong_to_many :organizations }
    it { should have_and_belong_to_many :communities }
    it { should have_and_belong_to_many :badges }
  end

  context 'validations' do
    let(:user) { User.new(valid_attributes) }

    before do
      User.create(valid_attributes)
    end

    it 'requires email and username to be unique' do
      expect(user).to validate_uniqueness_of(:username)
      expect(user).to validate_uniqueness_of(:email)
    end

    it 'requires a unique email (case insensitive)' do
      user.email = 'ADAM@thehoick.com'
      expect(user).to validate_uniqueness_of(:email)
    end

    it 'requires the email address to look like an email address' do
      user.email = 'adam'
      expect(user).to_not be_valid
    end
  end

  describe '#downcase email' do
    it 'makes the email attribute lower case' do
      user = User.new(valid_attributes.merge(email: 'ADAM@thehoick.com'))
      expect{user.downcase_email}.to change{user.email}.from('ADAM@thehoick.com').to('adam@thehoick.com')
    end

    it 'downcases an email before saving' do
      user = User.new(valid_attributes)
      user.email = 'Adam@thehoick.com'
      expect(user.save).to be_truthy
      expect(user.email).to eq('adam@thehoick.com')
    end
  end

  describe '#generate_password_reset_token!' do
    let(:user) { create(:user) }

    it 'changes the password_reset_token attribute' do
      expect{user.generate_password_reset_token!}.to change{user.password_reset_token}
    end

    it 'calls SecureRandom.urlsafe_base64 to generate password_reset_token' do
      expect(SecureRandom).to receive(:urlsafe_base64)
      user.generate_password_reset_token!
    end
  end

  describe '#generate_user_merge_token!' do
    let(:user) { create(:user) }

    it 'changes the merge_token attribute' do
      expect{user.generate_user_merge_token!}.to change{user.merge_token}
    end

    it 'calls SecureRandom.urlsafe_base64 to generate merge_token' do
      expect(SecureRandom).to receive(:urlsafe_base64)
      user.generate_user_merge_token!
    end
  end

  describe '#facbook login' do
    it 'creates user from Facebook attributes' do
      user = User.create({facebook_id: '10152915557788',
                          first_name: 'Cheese',
                          last_name: 'Cheeese',
                          password: (0...50).map { ('a'..'z').to_a[rand(26)] }.join
                         })

      new_user = User.last

      expect(user.facebook_id).to eq('10152915557788')
      expect(user.id).to eq(new_user.id)
    end
  end
end
