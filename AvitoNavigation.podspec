Pod::Spec.new do |s|
  s.name                   = 'AvitoNavigation'
  s.module_name            = 'AvitoNavigation'
  s.version                = '0.0.0'
  s.summary                = 'Avito iOS Navigation by Timur Yusipov'
  s.homepage               = ''
  s.license                = 'Avito'
  s.author                 = { 'Timur Yusipov' => 'tyusipov@avito.ru' }
  s.source                 = { :git => 'ssh://git@stash.msk.avito.ru:7999/ma/avito-ios-navigation.git', :tag => '#{s.version}' }
  s.platform               = :ios, '8.0'
  s.ios.deployment_target = "8.0"
  s.requires_arc = true
  s.source_files = 'Avito-ios-navigation/**/*.{swift}'
  s.exclude_files = 'Avito-ios-navigation/AppDelegate.swift', 'Demo/**/*.*'
end