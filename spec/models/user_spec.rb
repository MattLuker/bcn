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

    it 'will use email address for username if username is blank' do
      user = User.new({email: 'adam@thehoick.com', password: 'beans'})
      expect(user.save).to be_truthy
      expect(user.username).to eq(user.email)
    end
  end
end
