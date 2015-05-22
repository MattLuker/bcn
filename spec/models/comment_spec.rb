require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:valid_attributes) {
    { content: 'Great post...' }
  }

  context 'relationships' do
    it { should belong_to :post }
    it { should belong_to :user }
  end

  let(:comment) { Comment.new(valid_attributes) }

  before do
    Comment.create(valid_attributes)
  end

  it 'requires content to not be empty' do
    expect(comment).to validate_presence_of(:content)
  end
end
