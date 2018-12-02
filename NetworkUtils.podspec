#
# Be sure to run `pod lib lint NetworkUtils.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NetworkUtils'
  s.version          = '0.1.0'
  s.summary          = 'Swift package for handling HTTP requests'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    NetworkUtils is a simple package to handle HTTP requests.
                       DESC

  s.homepage         = 'https://github.com/Ryucoin/NetworkUtils'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'WyattMufson' => 'wyatt@ryucoin.com' }
  s.source           = { :git => 'https://github.com/Ryucoin/NetworkUtils.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/officialryucoin'

  s.ios.deployment_target = '12.0'
  s.swift_version = '4.2'

  s.source_files = 'NetworkUtils/Classes/**/*'
  
  # s.resource_bundles = {
  #   'NetworkUtils' => ['NetworkUtils/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
