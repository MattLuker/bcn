require 'rails_helper'

RSpec.describe Location, type: :model do
  it { should have_and_belong_to_many(:posts) }
  it { should belong_to(:community) }
  it { should belong_to(:organization) }
end
