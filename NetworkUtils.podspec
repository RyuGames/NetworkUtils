Pod::Spec.new do |s|
  s.name             = 'NetworkUtils'
  s.version          = '2.0.0'
  s.summary          = 'Swift package for handling HTTP requests'
  s.homepage         = 'https://github.com/RyuGames/NetworkUtils'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'WyattMufson' => 'wyatt@ryu.games' }
  s.source           = { :git => 'https://github.com/RyuGames/NetworkUtils.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.3'
  s.source_files = 'NetworkUtils/Classes/**/*'
  s.dependency 'SwiftPromises', '2.0.0'

  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
