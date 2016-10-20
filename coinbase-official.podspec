Pod::Spec.new do |s|
  s.name             = "coinbase-official"
  s.version          = "3.3.0"
  s.summary          = "Integrate bitcoin into your iOS application."
  s.description      = <<-DESC
                       Integrate bitcoin into your iOS application with Coinbase's fully featured bitcoin payments API. Coinbase allows all major operations in bitcoin through one API. For more information, visit https://coinbase.com/docs/api/overview.
                       DESC
  s.homepage         = "https://github.com/coinbase/coinbase-ios-sdk"
  s.license          = 'MIT'
  s.author           = { "Dai Hovey" => "dai@coinbase.com" }
  s.source           = { :git => "https://github.com/coinbase/coinbase-ios-sdk.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/coinbase'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.ios.resource_bundle = { 'CBCertificates' => 'Pod/Assets/Certificates/*.der' }
  s.frameworks = 'UIKit'

  s.subspec 'core' do |ss|
    ss.source_files = 'Pod/Classes/CoinbaseDefines.[hm]'
  end

  s.subspec 'OAuth' do |ss|
    ss.dependency 'coinbase-official/core'
    ss.source_files = 'Pod/Classes/OAuth/*.[hm]'
    ss.public_header_files = 'Pod/Classes/OAuth/*.h'
  end

  s.subspec 'client' do |ss|
    ss.dependency 'coinbase-official/core'
    ss.source_files = 'Pod/Classes/Client/*.[hm]'
    ss.public_header_files = 'Pod/Classes/Client/*.h'
  end
end
