Pod::Spec.new do |s|

  s.name         = "Bit6UI"
  s.version      = "0.9.8"
  s.summary      = "Bit6UI Framework"

  s.description  = <<-DESC
                   Bit6 is a real-time, cloud-based communications-as-a-service platform that allows mobile and web 
                   application developers to quickly and easily add voice/video calling, texting, and multimedia 
                   messaging capabilities into their apps.
                   DESC
  s.license      = { :type => 'MIT' }

  s.homepage     = "http://bit6.github.io/bit6-ios-sdk/"
  s.authors            = { "Carlos Thurber" => "carlos@voxofon.com", "Alexey Goloshubin" => "alexey@voxofon.com" }
  s.social_media_url   = "http://twitter.com/bit6com"

  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/bit6/bit6-ios-sdk.git", :tag => s.version }

  s.vendored_frameworks = "Bit6UI.framework"

  s.resource_bundle = { 'Bit6UIResources' => 'Bit6UIResources.bundle/*.*' }

  s.requires_arc = true
  
  s.dependency 'Bit6', '~> 0.9.8'

end