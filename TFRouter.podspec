
Pod::Spec.new do |s|

  s.name         = "TFRouter"
  s.version      = "1.2.0"
  s.summary      = "a router development tool for iOS app"
  s.description  = <<-DESC
    a router development tool for iOS app
                   DESC
  s.homepage     = "https://github.com/shmxybfq/TFRouter"
  s.license      = "MIT"
  s.author             = { "zhutaofeng" => "shmxybfq@163.com" }
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/shmxybfq/TFRouter.git", :tag => "#{s.version}" }
  s.source_files  = "TFRouter/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
  s.requires_arc = true
end
