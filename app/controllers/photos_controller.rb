class PhotosController < ApplicationController
  before_filter :require_user
  before_filter :check_admin

  def index
    @photos = Photo.all
  end

  def create
    respond_to do |format|
      @photo = Photo.new(photo_params)
      @photo.save
      format.html { redirect_to new_photo_path }
      format.js
    end
  end

  def new_multiple
    @photos = Photo.order('created_at DESC')
    @photo = Photo.new
  end

  def destroy
    @photo = Photo.find(params[:id])
    if @photo.destroy
      flash[:success] = 'Photo successfully deleted.'
      redirect_to photos_path
    else
      flash[:alert] = 'There was a problem deleting the Photo.'
      redirect_to photos_path
    end
  end

  private
    def check_admin
      unless current_user.admin?
        flash[:error] = 'Page not available.'
        redirect_to home_path
      end
    end
end
