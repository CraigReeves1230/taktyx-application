module PhotosHelper

  # Displays a reduced sized photo
  def display_photo(photo)
    link_to image_tag(photo.image.reduced.url), photo_full_path(photo)
  end

  # Displays a full sized photo
  def display_photo_full(photo)
    image_tag(photo.image.url)
  end

  # Displays a thumb sized photo
  def display_photo_thumb(photo)
    link_to image_tag(photo.image.thumb.url), photo_path(photo)
  end

  # Displays a user's profile pic
  def display_profile_pic(user)
    unless user.profile_pic.nil?
      photo = Photo.find_by_id(user.profile_pic)
      image_tag(photo.image.avatar.url)
    end
  end

end
