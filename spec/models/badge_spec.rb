require 'rails_helper'

RSpec.describe Badge, type: :model do
  context 'relationships' do
    it { should have_and_belong_to_many :users }
  end
end