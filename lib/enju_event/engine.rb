require "enju_message"
require "ri_cal"
require "csv"
require "nkf"
require "jbuilder"
begin
  require 'charlock_holmes/string'
rescue LoadError
end

module EnjuEvent
  class Engine < ::Rails::Engine
  end
end
