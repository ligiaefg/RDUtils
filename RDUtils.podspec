Pod::Spec.new do |s|

  s.name         = "RDUtils"
  s.version      = "0.0.2"
  s.summary      = "Group of iOS Utils used on most of the projects."

  s.description  = <<-DESC
                   Group of iOS Utils used on most of the projects.
                   DESC

  s.homepage     = "https://github.com/robertodias180/RDUtils"

  s.license      = "MIT"

  s.author             = { "Roberto Dias" => "robertodias180@gmail.com" }

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/robertodias180/RDUtils.git", :tag => "0.1.0" }


  s.frameworks = 'UIKit', 'Foundation', 'CoreGraphics', 'AVFoundation'

  s.requires_arc = true

  s.subspec 'RDAnalitics' do |spec|
    spec.source_files   = "RDUtils/RDAnalitics/*.{h,m}"
    spec.dependency 'FlurrySDK/FlurrySDK'
    spec.dependency 'GoogleAnalytics-iOS-SDK'
  end

end
