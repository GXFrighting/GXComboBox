Pod::Spec.new do |s|
  s.name             = 'GXComboBox'
  s.version          = '1.1.0'
  s.summary          = 'A view for comboBox'
  s.description      = <<-DESC
                      A view for comboBox name GXComboBox.
                       DESC

  s.homepage         = 'https://github.com/GXFrighting/GXComboBox'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'JGX' => '157610665@qq.com' }
  s.source           = { :git => 'https://github.com/GXFrighting/GXComboBox.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'GXComboBox/Classes/**/*'
  
  s.resource_bundles = {
    'GXComboBox' => ['GXComboBox/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
