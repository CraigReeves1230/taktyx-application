class PhotosController < ApplicationController
  before_action :set_photo, only: [:show, :edit, :update, :destroy]
  before_action :verify_activation
  before_action :require_logged_in

  def index
    @photos = @current_user.photos.all
  end

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
      flash.now[:danger] = "Problem uploading image: #{@photo.errors}."
      render 'new'
    end
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


  def destroy
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
