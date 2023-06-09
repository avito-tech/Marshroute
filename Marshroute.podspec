Pod::Spec.new do |s|
  s.name                   = 'Marshroute'
  s.module_name            = 'Marshroute'
  s.version                = '1.0.1'
  s.summary                = 'Marshroute by Timur Yusipov'
  s.homepage               = 'https://github.com/avito-tech/Marshroute'
  s.license                = 'MIT'
  s.author                 = { 'Timur Yusipov' => 'tyusipov@avito.ru' }
  s.source                 = { :git => 'https://github.com/avito-tech/Marshroute.git', :tag => s.version }
  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '9.0'
  s.requires_arc = true
  s.swift_version = '5.0'
  s.source_files = 'Marshroute/Sources/**/*.{swift}'
end
