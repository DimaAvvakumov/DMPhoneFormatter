Pod::Spec.new do |s|

  s.name         = "DMPhoneFormatter"
  s.version      = "0.0.3"
  s.summary      = "Helper for perform network requests"
  s.homepage     = "https://github.com/DimaAvvakumov/DMPhoneFormatter.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Dmitry Avvakumov" => "avvakumov@it-baker.ru" }
  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/DimaAvvakumov/DMPhoneFormatter.git" }
  s.source_files = "Pod/*.{h,m}"
  s.public_header_files = "Pod/*.{h}"
  s.framework    = "UIKit"
  s.requires_arc = true
  s.resources    = 'Pod/DMPhoneFormatterPresets.plist'

end
