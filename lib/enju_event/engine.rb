require "enju_core"
require "inherited_resources"
require "has_scope"
require "paperclip"
require "state_machine"
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
