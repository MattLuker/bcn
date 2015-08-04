require 'rails_helper'

RSpec.describe Badge, type: :model do
  context 'relationships' do
    it { should have_and_belong_to_many :users }
  end

  let(:valid_attributes) {
    {
        name: 'Comment Beginner',
        description: 'Commented more than 5 times!',
        rules: 'user.comments.count > 5',
    }
  }

  context 'validations' do
    let(:badge) { Badge.new(valid_attributes) }

    before do
      Badge.create(valid_attributes)
    end

    it 'disallows destroy in rules' do
      should allow_value('user.comments.count > 5').for(:rules)
      should_not allow_value('user.destroy').for(:rules)
    end
  end

  end