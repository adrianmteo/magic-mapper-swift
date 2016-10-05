Pod::Spec.new do |s|

  s.name         = "MagicMapper"
  s.version      = "1.0.1"
  s.summary      = "Automatic JSON to model mapper"
  s.homepage     = "https://github.com/adrianitech/magic-mapper-swift"
  s.license      = { :type => "Apache License 2.0", :file => "LICENSE" }
  s.author       = { "Adrian Mateoaea" => "adrianitech@gmail.com" }

  s.ios.deployment_target = '9.0'
  s.platform = :ios, '9.0'

  s.source       = { :git => "https://github.com/adrianitech/magic-mapper-swift.git", :tag => "#{s.version}" }
  s.source_files = "MagicMapper", "MagicMapper/*.swift"

end
