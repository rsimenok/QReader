Pod::Spec.new do |s|
  s.name         = 'QReader'
  s.version      = '0.0.1'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage     = 'https://github.com/rsimenok/QReader'
  s.authors 	 = { 'Roman Simenok' => 'roma.simenok@ukr.net' }
  s.summary		 = 'QR Core Reader for iOS based on AVFoundation.'
  s.source 		 = { :git => 'https://github.com/rsimenok/QReader.git',
  					 :tag => s.version.to_s }
  s.platform	 = :ios, '7.0'
  s.source_files = ['QReader/*.{h,m}']
  s.framework    = 'AVFoundation'
  s.requires_arc = true
end
