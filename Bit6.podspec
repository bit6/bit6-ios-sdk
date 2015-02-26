Pod::Spec.new do |s|

  s.name         = "Bit6"
  s.version      = "0.8.5"
  s.summary      = "Bit6 Framework"

  s.description  = <<-DESC
                   Bit6 is a real-time, cloud-based communications-as-a-service platform that allows mobile and web 
                   application developers to quickly and easily add voice/video calling, texting, and multimedia 
                   messaging capabilities into their apps.
                   DESC
  s.license      = { :type => 'Commercial' }

  s.homepage     = "http://bit6.github.io/bit6-ios-sdk/"
  s.authors            = { "Carlos Thurber" => "carlos@voxofon.com", "Alexey Goloshubin" => "alexey@voxofon.com" }
  s.social_media_url   = "http://twitter.com/bit6com"

  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/bit6/bit6-ios-sdk.git", :tag => s.version }

  s.vendored_frameworks = "Bit6SDK.framework"

  s.preserve_paths = "Bit6Resources.bundle/**/*"

  s.frameworks = "GLKit", "CoreMedia", "AudioToolbox", "AVFoundation", "AssetsLibrary", "SystemConfiguration", "MediaPlayer", "CoreLocation"
  s.libraries = "icucore", "z", "stdc++", "sqlite3"
  s.requires_arc = true
  
  s.xcconfig = {"ARCHS[sdk=iphonesimulator*]" => "$(ARCHS_STANDARD_32_BIT)", "ARCHS[sdk=iphoneos*]" => "$(ARCHS_STANDARD)"}

end