Pod::Spec.new do |s|
  s.name             = 'NetworkUtils'
  s.version          = '0.3.0'
  s.summary          = 'Swift package for handling HTTP requests'
  s.homepage         = 'https://github.com/Ryucoin/NetworkUtils'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'WyattMufson' => 'wyatt@ryucoin.com' }
  s.source           = { :git => 'https://github.com/Ryucoin/NetworkUtils.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/_ryugames'

  s.ios.deployment_target = '12.0'
  s.swift_version = '5'
  s.source_files = 'NetworkUtils/Classes/**/*'
  s.dependency 'PromisesSwift'
end
