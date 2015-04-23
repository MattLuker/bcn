require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do
  describe 'GET new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe 'POST create' do
    context 'with a valid user and email' do
      let(:user) { create(:user) }

      it 'finds the user' do
        expect(User).to receive(:find_by).with(email: user.email).and_return(user)
        post :create, email: user.email
      end

      it 'generates a new password_reset_token' do
        expect{ post :create, email: user.email; user.reload }.to change{user.password_reset_token}
      end

      it 'it sends a reset password email' do
        expect{ post :create, email: user.email }.to change(ActionMailer::Base.deliveries, :size)
      end

      it 'sets the flash success message' do
        post :create, email: user.email
        expect(flash[:success]).to match(/check your email/)
      end
    end

    context 'with no user found' do
      it 'renders the new page' do
        post :create, email: 'none@notfound.com'
        expect(response).to render_template('new')
      end

      it 'sets the flash notice message' do
        post :create, email: 'none@notfound.com'
        expect(flash[:notice]).to match(/not found/)
      end
    end
  end

  describe 'GET edit' do
    context 'with a valid password_reset_token' do
      let(:user) { create(:user) }
      before { user.generate_password_reset_token! }

      it 'renders the edit template' do
        get :edit, id: user.password_reset_token
        expect(response).to render_template('edit')
      end

      it 'assigns a @user' do
        get :edit, id: user.password_reset_token
        expect(assigns(:user)).to eq(user)
      end
    end

    context 'with no password_reset_token found' do
      it 'renders the 404 page' do
        get :edit, id: 'notfound'
        expect(response.status).to eq(404)
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
      end
    end
  end

  describe 'PATCH update' do
    context 'with no token found' do
      it 'renders the edit page' do
        patch :update, id: 'notfound', user: { password: 'beans' }
        expect(response).to render_template('edit')
      end

      it 'sets the flash message' do
        patch :update, id: 'notfound', user: { password: 'beans' }
        expect(flash[:notice]).to match(/not found/)
      end
    end

    context 'with a valid token' do
      let(:user) {create(:user)}
      before { user.generate_password_reset_token! }

      it 'updates the users password' do
        digest = user.password_digest
        patch :update, id: user.password_reset_token, user: {password: 'brains'}
        user.reload
        expect(user.password_digest).to_not eq(digest)
      end

      it 'clears the password_reset_token' do
        patch :update, id: user.password_reset_token, user: {password: 'brains'}
        user.reload
        expect(user.password_reset_token).to be_blank
      end

      it 'logs the user in by setting the session[:user_id]' do
        patch :update, id: user.password_reset_token, user: {password: 'brains'}
        expect(session[:user_id]).to eq(user.id)
      end

      it 'sets the flash[:success] message' do
        patch :update, id: user.password_reset_token, user: {password: 'brains'}
        expect(flash[:success]).to match(/password updated/i)
      end

      it 'redirects to home' do
        patch :update, id: user.password_reset_token, user: {password: 'brains'}
        expect(response).to redirect_to(home_path)
      end
    end
  end
end
