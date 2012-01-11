class C2DM::Device < C2DM::Base
  belongs_to :app, :class_name => "C2DM::App"
  has_many :notifications, :class_name => "C2DM::Notification", :dependent => :destroy
end