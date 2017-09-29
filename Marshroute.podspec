Pod::Spec.new do |s|
  s.name                   = 'Marshroute'
  s.module_name            = 'Marshroute'
  s.version                = '0.4.2'
  s.summary                = 'Marshroute by Timur Yusipov'
  s.homepage               = 'https://github.com/avito-tech/Marshroute'
  s.license                = 'MIT'
  s.author                 = { 'Timur Yusipov' => 'tyusipov@avito.ru' }
  s.source                 = { :git => 'https://github.com/avito-tech/Marshroute.git', :tag => s.version }
  s.platform               = :ios, '8.0'
  s.ios.deployment_target = "8.0"
  s.requires_arc = true
  s.source_files = 'Marshroute/Sources/**/*.{swift}'
end
