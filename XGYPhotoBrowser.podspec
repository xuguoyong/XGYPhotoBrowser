
Pod::Spec.new do |s|
  s.name         = "XGYPhotoBrowser"
  s.version      = "1.0.4"
  s.summary      = "XGYPhotoBrowser."
  s.description  = <<-DESC
                    图片浏览器 高仿微信 微博 今日头条
                   DESC
  s.homepage     = "https://github.com/xuguoyong/XGYPhotoBrowser.git"
  s.license      = {
                     :type => 'Copyright',
                     :text => <<-LICENSE
                      Copyright guoyong xu. All rights reserved.
                      LICENSE
  }
  s.author             = {"xuguoyong" => "jasondevios@outlook.com"}
  s.source       = { :git => "https://github.com/xuguoyong/XGYPhotoBrowser.git",:tag => "1.0.3"  }
  s.ios.deployment_target = "8.0"
  s.source_files = "XGYPtotoBrowser/*.{h,m}"
  s.dependency 'YYWebImage'
  s.requires_arc = true
end
