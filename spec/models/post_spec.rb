require 'rails_helper'

RSpec.describe Post, type: :model do

  context 'relationshipos' do
    it { should have_and_belong_to_many(:locations) }
    it { should belong_to(:user) }
    it { should have_and_belong_to_many(:communities) }
  end
end
