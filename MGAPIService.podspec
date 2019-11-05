Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '9.0'
s.name = "MGAPIService"
s.summary = "Network layer, built on top of RxAlamofire"
s.requires_arc = true

# 2
s.version = "1.1.1"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Tuan Truong" => "tuan188@gmail.com" }

# 5 - Replace this URL with your own GitHub page's URL (from the address bar)
s.homepage = "https://github.com/tuan188/MGAPIService"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/tuan188/MGAPIService.git",
             :tag => "#{s.version}" }

# 7
s.framework = "UIKit"
s.dependency 'RxSwift', '~> 5.0'
s.dependency 'RxAlamofire', '~> 5.0'
s.dependency 'ObjectMapper', '~> 3.5'

# 8
s.source_files = "MGAPIService/Sources/*.{swift}"

# 9
# s.resources = "MGAPIService/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

# 10
s.swift_version = "5.0"

end
