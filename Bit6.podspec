Pod::Spec.new do |s|

  s.name         = "Bit6"
  s.version      = "0.10.1"
  s.summary      = "Bit6 Framework"

  s.description  = <<-DESC
                   Bit6 is a real-time, cloud-based communications-as-a-service platform that allows mobile and web 
                   application developers to quickly and easily add voice/video calling, texting, and multimedia 
                   messaging capabilities into their apps.
                   DESC
  s.license      = { :type => 'MIT' }

  s.homepage     = "http://bit6.github.io/bit6-ios-sdk/"
  s.authors            = { "Carlos Thurber" => "carlos@voxofon.com", "Alexey Goloshubin" => "alexey@voxofon.com" }
  s.social_media_url   = "http://twitter.com/bit6com"

  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/bit6/bit6-ios-sdk.git", :tag => s.version }

  s.vendored_frameworks = "Bit6.framework"
  s.documentation_url = "http://docs.bit6.com/api/ios/index.html"

  s.frameworks = "GLKit", "VideoToolbox"
  s.libraries = "icucore", "stdc++"
  s.requires_arc = true
  
  s.xcconfig = {"ARCHS[sdk=iphonesimulator*]" => "$(ARCHS_STANDARD_32_BIT)", "ARCHS[sdk=iphoneos*]" => "$(ARCHS_STANDARD)", "ENABLE_BITCODE" => "NO"}

end