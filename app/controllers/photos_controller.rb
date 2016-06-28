class PhotosController < ApplicationController
  before_action :set_photo, only: [:show, :profile_pic, :edit, :update, :destroy, :photo_large]
  before_action :verify_activation
  before_action :require_logged_in

  def show
  end

  def new
    @photo = @current_user.photos.build
  end

  def edit
  end

  def create
    @photo = @current_user.photos.build(photo_params)
    if @photo.save
      redirect_to photo_path(@photo)
    else
      flash.now[:danger] = "Problem uploading photo."
      render 'new'
    end
  end

  def index
    @photos = @current_user.all_photos
  end

  def profile_pic
    if @current_user.update_attribute(:profile_pic, @photo.id)
      redirect_to photos_url
    else
      flash.now[:danger] = "There was a problem updating the profile picture."
      render 'index'
    end
  end

  def reject_profile
    @current_user.update_attribute(:profile_pic, nil)
    redirect_to photos_url
  end

  def update
    if @photo.update_attribute(:description, params[:photo][:description])
      flash.now[:success] = "Photo description successfully updated."
      render 'show'
    else
      flash.now[:danger] = "There was problem updating the photo."
      render 'show'
    end
  end

  def photo_large
  end

  def destroy
    # Remove photo as a profile pic if it is the avatar
    if @current_user.profile_pic == @photo.id
      @current_user.update_attribute(:profile_pic, nil)
    end
    @photo.destroy
    redirect_to photos_path
  end

  private

    def set_photo
      @photo = @current_user.photos.find(params[:id])
    end

    def photo_params
      params.require(:photo).permit(:description, :image)
    end
end
