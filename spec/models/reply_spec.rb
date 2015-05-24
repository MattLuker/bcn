require 'rails_helper'

RSpec.describe Reply, type: :model do
  let(:valid_attributes) {
    { content: 'Great reply...' }
  }

  context 'relationships' do
    it { should belong_to :comment }
    it { should belong_to :user }
  end

  let(:reply) { Reply.new(valid_attributes) }

  before do
    Reply.create(valid_attributes)
  end

  it 'requires content to not be empty' do
    expect(reply).to validate_presence_of(:content)
  end
end
