Pod::Spec.new do |s|

s.name             = "UberKit"
s.version          = "0.1.1"
s.summary          = "A simple, easy-to-use Objective C wrapper for the Uber API."
s.homepage         = "https://github.com/sachinkesiraju/UberKit"
s.license          = { :type => 'MIT', :text => 'Copyright 2014 Sachin Kesiraju' }
s.author           = { "Sachin Kesiraju" => "me@sachinkesiraju.com" }
s.source           = { :git => "https://github.com/sachinkesiraju/UberKit.git", :tag => '0.1.1'}
s.social_media_url = "https://twitter.com/sachinkesiraju"
s.platform     = :ios, '7.0'
s.requires_arc = true
s.source_files = 'UberKit', 'UberKit/**/*.{h,m}'


end

