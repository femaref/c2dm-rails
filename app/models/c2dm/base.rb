module C2dm
  class Base < ActiveRecord::Base
    self.abstract_class = true
  end
end