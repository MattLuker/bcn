class CommunitiesController < ApplicationController
  before_action :set_community, only: [:show, :edit, :update, :destroy]
  before_filter :require_user, only: [:new, :create, :update, :destroy, :add_user, :remove_user]

  # GET /communities
  # GET /communities.json
  def index
    @communities = Community.all
  end

  # GET /communities/1
  # GET /communities/1.json
  def show
  end

  # GET /communities/new
  def new
    @community = Community.new
  end

  # GET /communities/1/edit
  def edit
    if @community.created_by != current_user.id
      redirect_to @community, notice: 'Must be the creator of the Community to update it.'
    end
  end

  # POST /communities
  # POST /communities.json
  def create
    @community = Community.new(community_params)
    @community.created_by = current_user.id
    @community.users << current_user

    respond_to do |format|
      if @community.save
        format.html { redirect_to @community, notice: 'Community was successfully created.' }
        format.json { render :show, status: :created, location: @community }
      else
        format.html { render :new }
        format.json { render json: @community.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /communities/1
  # PATCH/PUT /communities/1.json
  def update
    respond_to do |format|
      if @community.created_by != current_user.id
        format.html { redirect_to @community, notice: 'Must be the creator of the Community to update it.' }
      else
        if @community.update(community_params)
          format.html { redirect_to @community, notice: 'Community was successfully updated.' }
          format.json { render :show, status: :ok, location: @community }
        else
          format.html { render :edit }
          format.json { render json: @community.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /communities/1
  # DELETE /communities/1.json
  def destroy
    if @community.created_by == current_user.id
      @community.destroy
      respond_to do |format|
        format.html { redirect_to communities_url, notice: 'Community was successfully deleted.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to @community, notice: 'Community can only be deleted by creator.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_community
      @community = Community.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def community_params
      params.require(:community).permit(:name, :description, :home_page, :color)
    end
end
