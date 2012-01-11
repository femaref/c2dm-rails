require 'rails'

module C2dm
  module Generators
    class MigrationsGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
  
  
      def generate_migration
        timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
        db_migrate_path = File.join('db', 'migrate')
    
        Dir.glob(File.join(File.dirname(__FILE__), 'templates', '*.rb')).sort.each_with_index do |f, i|
          f = File.basename(f)
          f.match(/\d+\_(.+)/)
          timestamp = timestamp.succ
          if Dir.glob(File.join(db_migrate_path, "*_#{$1}")).empty?
            copy_file f, File.join(db_migrate_path, "#{timestamp}_#{$1}")
          end
        end
    
      end
    end
  end
end