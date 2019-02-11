Pod::Spec.new do |spec|

spec.name        = "cyberpaysdk"
spec.author    = "Cyberspace Network Limited"
spec.version       = "1.0.0"
spec.summary      = "An sdk for the cyberpay payment gateway."
spec.description  = "The cyberpay sdk aids ios developers integrating with the cyberpay SDK, and also provides some custom views for quick intergration with your app"
spec.homepage     = "https://github.com/cyberspace-ltd/cyberpay-ios"
spec.license      = "MIT"
spec.platform     = :ios, "9.0"
spec.source          = { :git => "https://github.com/cyberspace-ltd/cyberpay-ios.git", :tag =>  "#{spec.version}" }
spec.source_files = "cyberpaysdk", "cyberpaysdk/**/*.{h,m,swift}"
spec.resources = "cyberpaysdk/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"
spec.swift_version = "4.2"
end
