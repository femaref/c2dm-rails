class C2dm::Device < C2dm::Base  
  belongs_to :app, :class_name => "C2dm::App"
  has_many :notifications, :class_name => "C2dm::Notification", :dependent => :destroy
end