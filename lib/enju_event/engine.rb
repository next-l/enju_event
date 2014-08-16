require "enju_seed"
require "enju_message"
require "inherited_resources"
require "has_scope"
require "paperclip"
require "statesman"
require "ri_cal"
require "csv"
require "nkf"
begin
  require 'charlock_holmes/string'
rescue LoadError
end

module EnjuEvent
  class Engine < ::Rails::Engine
  end
end
