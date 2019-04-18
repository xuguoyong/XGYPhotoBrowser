
Pod::Spec.new do |s|
  s.name         = "XGYPhotoBroswer"
  s.version      = "1.0.0"
  s.summary      = "XGYPhotoBroswer."
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
  s.source       = { :git => "https://github.com/xuguoyong/XGYPhotoBrowser",:tag => "1.0.0"  }
  s.ios.deployment_target = "8.0"
  s.resources    = "XGYPtotoBrowser/XGYPtotoBrowser/*.{png,bundle}"
  s.source_files = "XGYPtotoBrowser/XGYPtotoBrowser/*.{h,m}"
  s.dependency 'YYWebImage'
  s.requires_arc = true
end
