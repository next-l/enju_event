require "enju_message"
require "statesman"
require "ri_cal"
require "csv"
require "nkf"
require "mini_magick"
require "refile/rails"
require "refile/image_processing"
begin
  require 'charlock_holmes/string'
rescue LoadError
end

module EnjuEvent
  class Engine < ::Rails::Engine
  end
end
