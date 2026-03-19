Rails.application.config.before_initialize do
  cloudinary_service_gem = Gem.loaded_specs["activestorage-cloudinary-service"]
  require File.join(cloudinary_service_gem.full_gem_path, "lib/active_storage/service/cloudinary_service")
end