module CarrierWave
  module MiniMagick
    def quality(percentage)
      manipulate! do |img|
        img.quality(percentage.to_s)
        img = yield(img) if block_given?
        img
      end
    end

    def auto_orient
      manipulate! do |img|
        img.tap(&:auto_orient)
      end
    end
  end
end

CarrierWave.configure do |config|
  if Rails.env.production? || Rails.env.staging?
    config.storage :fog
    # Cache Dir is needed to work with TMP files on Heroku
    # This way the image will be displayed between form redisplays
    config.cache_dir = "tmp"
    # the following configuration works for Amazon S3
    config.fog_credentials  = {
      path_style:            true,  # https://github.com/carrierwaveuploader/carrierwave/issues/1262#issuecomment-28205460
      provider:              ENV['FOG_PROVIDER'],
      region:                ENV['FOG_REGION'],
      aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    }
    config.asset_host = "https://#{ENV['ASSET_HOST']}"
    config.fog_directory = ENV['FOG_DIRECTORY']
  else
    config.asset_host = ENV['ASSET_HOST']
    config.storage :file
    config.enable_processing = false
  end
end

