
Pod::Spec.new do |s|
  s.name         = "XGYPhotoBroswer"
  s.version      = "1.0.0"
  s.summary      = "XGYPhotoBroswer."
  s.homepage     = "https://github.com/xuguoyong/XGYPhotoBrowser.git"
  s.license      = {
  :type => 'Copyright',
  :text => <<-LICENSE
  Copyright 2017 finogeeks.com. All rights reserved.
  LICENSE
  }
  s.author             = { "xuguoyong" => "jasondevios@outlook.com" }
  s.source       = { :git => "https://github.com/xuguoyong/XGYPhotoBrowser",:tag => s.version.to_s  }
  s.ios.deployment_target = "8.0"
  s.libraries = 'Object-C'
  s.requires_arc = true
end
