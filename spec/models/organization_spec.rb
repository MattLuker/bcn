require 'rails_helper'

RSpec.describe Organization, type: :model do
  let(:valid_attributes) {
    {
        name: 'Bacon Band',
        email: 'bacon@thehoick.com',
        description: 'Band from Boone, NC',
        password: 'beans',
        web_url: 'http:///thehoick.com',
        slug: 'bacon-band'
    }
  }

  context 'relationships' do
    it { should have_and_belong_to_many :posts }
    it { should have_and_belong_to_many :users }
    it { should have_and_belong_to_many :communities }
    it { should have_many :comments }
    it { should have_many :facebook_subscriptions }
    it { should have_one :location }
  end

  context 'validations' do
    let(:organization) { Organization.new(valid_attributes) }

    before do
      Organization.create(valid_attributes)
    end

    it 'requires links to have protocol' do
      organization.web_url = 'thehoick.com'
      expect(organization).to_not be_valid
      organization.web_url = 'http://thehoick.com'
      expect(organization).to be_valid


      organization.facebook_link = 'facebook.com'
      expect(organization).to_not be_valid
      organization.facebook_link = 'https://facebook.com'
      expect(organization).to be_valid

      organization.twitter_link = 'twitter.com'
      expect(organization).to_not be_valid
      organization.twitter_link = 'ftp://twitter.com'
      expect(organization).to be_valid

      organization.google_link = 'google.com'
      expect(organization).to_not be_valid
      organization.google_link = 'ssh://google.com'
      expect(organization).to be_valid
    end
  end

  describe '#set_slug' do
    it 'creates slug string from name' do
      organization = Organization.new(valid_attributes.merge(name: 'Dr. Bacon Band'))
      expect{organization.set_slug}.to change{organization.slug}.from('bacon-band').to('dr-bacon-band')
    end
  end

  describe '#create_location' do
    it 'creates a new location' do
      organization = Organization.new(valid_attributes)
      organization.create_location({ lat: 36.2200414612719, lon: -81.6823196411133 })

      expect(organization.location.lat).to eq(36.2200414612719)
      expect(organization.location.name).to eq('Watauga County Public Library')
    end
  end
end
