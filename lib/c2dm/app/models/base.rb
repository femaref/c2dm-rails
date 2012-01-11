module C2DM
  class Base < ActiveRecord::Base
    def self.table_name # :nodoc:
      self.to_s.gsub("::", "_").tableize
    end
  end
end