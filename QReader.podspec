Pod::Spec.new do |s|
  s.name                  = 'QReader'
  s.version               = '0.0.1'
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.summary               = 'QR Code Reader for iOS based on AVFoundation'
  s.description           = 'The `QReader` is a simple QRCode and bar code scanner based on the `AVFoundation` framework from Apple. It aims to replace ZXing or ZBar for iOS 7 and over.'
  s.homepage              = 'https://github.com/rsimenok/QReader'
  s.authors               = { 'Roman Simenok' => 'roma.simenok@ukr.net' }
  s.source                = { :git => 'https://github.com/rsimenok/QReader.git',
                              :tag => s.version.to_s }
  s.requires_arc          = true
  s.source_files          = ['QReader/*.{h,m}']
  s.framework             = 'AVFoundation'
  s.ios.deployment_target = '7.0'
end
