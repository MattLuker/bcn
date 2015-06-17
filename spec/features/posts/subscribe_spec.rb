require 'rails_helper'

describe 'Subscribing to Post' do
  let(:user) { create(:user) }
  let!(:post) { Post.create(title: "Great Post", description: "Great job!") }

  it 'subscribes user to post', :js => true do
    sign_in user, password: 'beans'

    visit '/posts'
    click_link post.title

    find('.post-subscribe').click

    within '.post-subscribe' do
      expect(find('img')[:alt]).to eq('Tack icon green')
    end

    expect(post.subscribers[0].user).to eq(user)
  end

  it 'unsubscribes user to post', :js => true do
    sign_in user, password: 'beans'

    visit '/posts'
    click_link post.title

    find('.post-subscribe').click

    within '.post-subscribe' do
      expect(find('img')[:alt]).to eq('Tack icon green')
    end

    expect(post.subscribers[0].user).to eq(user)
    expect(post.subscribers.count).to eq(1)

    find('.post-subscribe').click
    within '.post-subscribe' do
      expect(find('img')[:alt]).to eq('Tack icon')
    end
    expect(post.subscribers.count).to eq(0)
  end

  it 'sends email to subscribes for new comment', :js => true do
    sign_in user, password: 'beans'

    visit '/posts'
    click_link post.title

    find('.post-subscribe').click
    sleep(1)
    expect(post.subscribers[0].user).to eq(user)

    click_link 'Log Out'

    visit '/posts'
    click_link post.title

    find('.comment-button').click
    fill_in 'comment[content]', with: 'Something to comment on...'

    expect {
      find('.save-comment').click
    }.to change{ ActionMailer::Base.deliveries.size }.by(1)

    open_email(user.email)
    expect(current_email.body).to have_content('Great Post')
  end

end