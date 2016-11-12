module ImportFile
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def expire
      stucked.find_each(&:destroy)
    end
  end
end
