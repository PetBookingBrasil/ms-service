class ServiceCategoryUploader < CarrierWave::Uploader::Base
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  include CarrierWave::Backgrounder::Delay

  # process :resize_and_convert_to_jpg_large
  # process convert: 'jpg'
  process :auto_orient

  def resize_and_convert_to_jpg_large
    manipulate! do |img|
      img.background '#FFFFFF'
      img.alpha 'remove'
      img.format 'jpg'
      img.resize '950x950'
      img
    end
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url(override_version_name=nil)
    filename = ['cover_image', (override_version_name || version_name)].compact.join('_')
    ActionController::Base.helpers.asset_url("fallbacks/#{filename}.png")
  end

  # Create different versions of your uploaded files:
  version :mobile_thumb do
    process resize_to_fill: [512, 512]
    process quality: 65
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
     %w(jpg jpeg gif png)
  end

  def filename
    if original_filename.blank?
      super
    else
      token =
        if original_filename =~ /\d{10}\.\w{3,4}/i
          super.chomp(File.extname(original_filename))
        else
          Time.now.to_i
        end
      "#{token}.#{file.extension}"
    end
  end
end
