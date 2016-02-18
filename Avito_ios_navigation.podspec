Pod::Spec.new do |s|
  s.name         = 'Avito_ios_navigation'
  s.version      = '0.0.0'
  s.summary      = 'Avito-ios-navigation by Timur Yusipov'
  s.homepage     = ''
  s.license      = 'MIT'
  s.author       = { 'Timur Yusipov' => 'tyusipov@avito.ru' }
  s.source       = { :git => 'http://tyusipov@stash.se.avito.ru/scm/ma/avito-ios-navigation.git', :branch => 'master' }
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  

  s.subspec 'Navigation' do |navigation|
    navigation.source_files = 'Avito-ios-navigation/**/*.{swift}'
  end

end