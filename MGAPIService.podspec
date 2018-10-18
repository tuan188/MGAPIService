Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '9.0'
s.name = "MGAPIService"
s.summary = "Network layer, built on top of RxAlamofire"
s.requires_arc = true

# 2
s.version = "0.1.4"

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
s.dependency 'RxSwift', '~> 4.1'
s.dependency 'RxAlamofire', '~> 4.2'
s.dependency 'ObjectMapper', '~> 3.3'

# 8
s.source_files = "MGAPIService/**/*.{swift}"

# 9
# s.resources = "MGAPIService/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

# 10
s.swift_version = "4.0"

end
