require 'rails_helper'

RSpec.describe UserSessionsController, type: :controller do

  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe 'POST #create' do
    context 'with correct credentials' do
      let!(:user) { User.create(email: 'adam@thehoick.com', password: 'beans') }

      it 'redirects to the home page' do
        post :create, email: 'adam@thehoick.com', password: 'beans'
        expect(response).to be_redirect
        expect(response).to redirect_to(home_path)
      end

      it 'finds the user' do
        expect(User).to receive(:find_by).with({email: 'adam@thehoick.com'}).and_return(user)
        post :create, email: 'adam@thehoick.com', password: 'beans'
      end

      it 'authenticates the user' do
        allow(User).to receive(:find_by).and_return(user)
        expect(user).to receive(:authenticate)
        post :create, email: 'adam@thehoick.com', password: 'beans'
      end

      it 'sets the user_id in the session' do
        post :create, email: 'adam@thehoick.com', password: 'beans'
        expect(session[:user_id]).to eq(user.id)
      end
    end

    shared_examples_for 'denied login' do
      it 'renders the new template' do
        post :create, email: email, password: password
        expect(response).to render_template('new')
      end

      it 'sets the flash alert message' do
        post :create, email: email, password: password
        expect(flash[:alert]).to eq('There was a problem logging in, please check you username and password.')
      end
    end

    context 'with blank credentials' do
      let(:email) {''}
      let(:password) {''}
      it_behaves_like 'denied login'
    end

    context 'with bad password' do
      let!(:user) { User.create(email: 'adam@thehoick.com', password: 'beans') }
      let(:email) {user.email}
      let(:password) {'barns'}
      it_behaves_like 'denied login'
    end

    context 'with no email in existence' do
      let!(:user) { User.create(email: 'adam@thehoick.com', password: 'beans') }
      let(:email) {'beans@thehoick.com'}
      let(:password) {'beans'}
      it_behaves_like 'denied login'
    end
  end

end
