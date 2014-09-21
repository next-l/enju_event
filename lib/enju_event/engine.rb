require "enju_seed"
require "enju_message"
require "paperclip"
require "statesman"
require "ri_cal"
require "csv"
require "nkf"
begin
  require 'charlock_holmes/string'
rescue LoadError
end
require "protected_attributes" if Rails::VERSION::MAJOR == 4

module EnjuEvent
  class Engine < ::Rails::Engine
  end
end
