Pod::Spec.new do |s|
s.name             = 'RQMana'
s.version          = '0.1.0'
s.summary          = 'Roy.Q Tools Set'

s.description      = <<-DESC
'A set of sereral utility for quick development'
DESC

s.homepage         = 'https://github.com/ruanqisevik/RQMana'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Q.Roy' => 'ruanqisevik@gmail.com' }
s.source           = { :git => 'https://github.com/ruanqisevik/RQMana.git', :tag => s.version.to_s }

s.ios.deployment_target = '9.0'

s.source_files = 'RQMana/Classes/**/*'

# s.public_header_files = 'Pod/Classes/**/*'
s.frameworks = 'UIKit', 'Foundation'

end

