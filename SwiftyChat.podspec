Pod::Spec.new do |spec|

  spec.name         = "SwiftyChat"
  spec.version      = "0.0.1"
  spec.summary      = "A chat controller written in Swift"

  spec.description  = <<-DESC
	This is an approach to make writing chat app easier and fast enough as just subclassing. 
                   DESC

  spec.homepage     = "https://github.com/hujaber/SwiftyChat"
  spec.license      = { :type => "MIT", :file => "LICENSE.txt" }  
  spec.author             = { "Hussein Jaber" => "hujaber@me.com" }

  spec.platform     = :ios, "11.0"

  spec.source       = { :git => "https://github.com/hujaber/SwiftyChat.git", :tag => "#{spec.version}" }

  spec.source_files  = "Classes", "Classes/**/*.{h,m}"
  spec.exclude_files = "Classes/Exclude"



end
