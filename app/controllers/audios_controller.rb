class AudiosController < ApplicationController
  before_filter :require_user
  before_filter :check_admin

  def index
    @audios = Audio.all
  end

  def destroy
    @audio = Audio.find(params[:id])
    if @audio.destroy
      flash[:success] = 'Audio file successfully deleted.'
      redirect_to audios_path
    else
      flash[:alert] = 'There was a problem deleting the Audio file.'
      redirect_to audios_path
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
