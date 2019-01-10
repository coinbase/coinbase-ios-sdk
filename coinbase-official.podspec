Pod::Spec.new do |s|
  s.name              = 'coinbase-official'
  s.version           = '4.0.0'
  s.summary           = 'Integrate bitcoin into your iOS application.'
  s.description       = <<-DESC
                       Integrate bitcoin into your iOS application with Coinbase's fully featured bitcoin payments API. Coinbase allows all major operations in bitcoin through one API. For more information, visit https://coinbase.com/docs/api/overview.
                       DESC
  s.homepage          = 'https://github.com/coinbase/coinbase-ios-sdk'
  s.license           = 'Apache License, Version 2.0'
  s.author            = { 'Coinbase' => 'sohail.khanifar@coinbase.com' }
  s.source            = { git: 'https://github.com/coinbase/coinbase-ios-sdk.git', tag: s.version.to_s }
  s.social_media_url  = 'https://twitter.com/coinbase'

  s.platforms     = { ios: '11.0' }
  s.requires_arc  = true
  s.frameworks    = 'UIKit'

  s.default_subspec = 'Core'
  s.subspec 'Core' do |ss|
    ss.resources = 'Source/**/*.cer'
    ss.source_files  = 'Source/**/*.swift'
    ss.exclude_files = 'Source/Extentions/RxSwift/**/*.swift'
    ss.framework  = 'Foundation'
  end
  s.subspec 'RxSwift' do |ss|
    ss.source_files = 'Source/Extentions/RxSwift/**/*.swift'
    ss.dependency 'coinbase-official/Core'
    ss.dependency 'RxSwift', '~> 4.0'
  end
end
