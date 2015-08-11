require 'rails_helper'

describe 'Subscribing to Post' do
  let(:user) { create(:user) }
  let!(:post) { Post.create(title: "Great Post", description: "Great job!") }

  it 'subscribes user to post', :js => true do
    sign_in user, password: 'beans'

    visit '/posts'
    find('#post_1').click

    find('.post-subscribe').click
    sleep(0.3)

    within '.post-subscribe' do
      expect(find('img')[:alt]).to eq('Tack icon green')
    end

    expect(post.subscribers[0].user).to eq(user)
  end

  it 'unsubscribes user to post', :js => true do
    sign_in user, password: 'beans'

    visit '/posts'
    find('#post_1').click

    find('.post-subscribe').click
    sleep(0.3)

    within '.post-subscribe' do
      expect(find('img')[:alt]).to eq('Tack icon green')
    end

    expect(post.subscribers[0].user).to eq(user)
    expect(post.subscribers.count).to eq(1)

    find('.post-subscribe').click
    sleep(0.3)

    within '.post-subscribe' do
      expect(find('img')[:alt]).to eq('Tack icon')
    end
    expect(post.subscribers.count).to eq(0)
  end

  it 'does not send email to subscribes for new comment if instant notify false', :js => true do
    sign_in user, password: 'beans'

    visit '/posts'
    find('#post_1').click

    find('.post-subscribe').click
    sleep(1)
    expect(post.subscribers[0].user).to eq(user)

    click_link 'Log Out'

    visit '/posts'
    find('#post_1').click

    find('.comment-button').click
    fill_in 'comment[content]', with: 'Something to comment on...'

    expect {
      find('.save-comment').click
    }.to change{ ActionMailer::Base.deliveries.size }.by(0)
  end

  it 'send email to subscribes for new comment if instant notify true', :js => true do
    sign_in user, password: 'beans'
    user.notify_instant = true
    user.save

    visit '/posts'
    find('#post_1').click

    find('.post-subscribe').click
    sleep(1)
    expect(post.subscribers[0].user).to eq(user)

    click_link 'Log Out'

    visit '/posts'
    find('#post_1').click

    find('.comment-button').click
    fill_in 'comment[content]', with: 'Something to comment on...'

    expect {
      find('.save-comment').click
    }.to change{ ActionMailer::Base.deliveries.size }.by(1)

    open_email(user.email)
    expect(current_email.body).to have_content('Great Post')
  end

end