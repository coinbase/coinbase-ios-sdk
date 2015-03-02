
Pod::Spec.new do |s|
  s.name             = "coinbase-official"
  s.version          = "2.0.1"
  s.summary          = "Integrate bitcoin into your iOS application."
  s.description      = <<-DESC
                       Integrate bitcoin into your iOS application with Coinbase's fully featured bitcoin payments API. Coinbase allows all major operations in bitcoin through one API. For more information, visit https://coinbase.com/docs/api/overview.
                       DESC
  s.homepage         = "https://github.com/coinbase/coinbase-ios-sdk"
  s.license          = 'MIT'
  s.author           = { "Isaac Waller" => "isaac@coinbase.com" }
  s.source           = { :git => "https://github.com/coinbase/coinbase-ios-sdk.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/coinbase'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resources = 'Pod/Assets'

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'

  s.subspec 'OAuth' do |ss|
    ss.source_files = 'Pod/Classes/{CoinbaseOAuth,CoinbaseDefines}.[hm]'
  end
end
