class Settings::BucketsController < SettingsController

  def index
    @buckets = current_user.buckets
  end
end
