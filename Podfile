# Uncomment the next line to define a global platform for your project
use_frameworks!

workspace 'VimeoNetworking'
project 'iTA.xcodeproj'

def shared_pods
	pod 'AFNetworking', '3.1.0'
	pod 'SwiftLint', '0.25.1'
	pod 'VimeoNetworking', :path => '../VimeoNetworking'
end

target 'iTA' do
  platform :ios, '9.0'
  shared_pods
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'SwiftyJSON', '~> 4.0'
  pod 'Alamofire', '~> 4.7'
  pod 'DLRadioButton', '~> 1.4'
  pod 'SwiftKeychainWrapper'
  pod 'SideMenu'
  pod 'HCVimeoVideoExtractor'
	pod 'Stripe'
  # Pods for iTA

  target 'iTATests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'iTAUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
