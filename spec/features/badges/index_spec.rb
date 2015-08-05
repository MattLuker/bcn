require 'rails_helper'

describe "Indexing badges" do
  it 'displays list of badges' do
    create_badge
    visit '/badges'
    expect(page).to have_content('Comment Beginner')
  end
end