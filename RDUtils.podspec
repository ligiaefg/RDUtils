Pod::Spec.new do |s|

  s.name         = "RDUtils"
  s.version      = "0.1.6"
  s.summary      = "Group of iOS Utils used on most of the projects."

  s.homepage     = "https://github.com/robertodias180/RDUtils"

  s.license      = "MIT"

  s.author             = { "Roberto Dias" => "robertodias180@gmail.com" }

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/robertodias180/RDUtils.git", :tag => "0.1.6" }


  s.frameworks = 'UIKit', 'Foundation', 'CoreGraphics', 'AVFoundation'

  s.requires_arc = true

  s.subspec 'RDAnalytics' do |spec|
    spec.source_files   = "RDUtils/RDAnalytics/*.{h,m}"
    spec.dependency 'FlurrySDK/FlurrySDK'
    spec.dependency 'GoogleAnalytics-iOS-SDK'
  end

  s.subspec 'RDReachability' do |spec|
    spec.source_files   = "RDUtils/RDReachability/*.{h,m}"
  end

  s.subspec 'WMAdManager' do |spec|

    spec.subspec 'Core' do |sub|
    sub.source_files   = "RDUtils/WMAdManager/WMCore/*.{h,m}"
    sub.dependency 'RDUtils/RDReachability'
    sub.dependency 'RDUtils/RDAnalytics'
    end


    spec.subspec 'WMAdColony' do |sub|
    sub.source_files   = "RDUtils/WMAdManager/WMNetworks/WMAdColony.{h,m}"
    sub.dependency 'AdColony'
    sub.dependency 'RDUtils/WMAdManager/Core'
    end

  end

end
