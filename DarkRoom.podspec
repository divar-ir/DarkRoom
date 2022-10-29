Pod::Spec.new do |s|

  s.name         = "DarkRoom"
  s.version      = "1.1.1"
  s.summary      = "Elegant Media Viewer Written In Swift."

  s.description  = <<-DESC
                   Supports Loading Videos And Images Locally And Remotely With Showy Animation And Full Control Over Video Player.
                   DESC

  s.homepage     = "https://github.com/divar-ir/DarkRoom"
  s.screenshots  = "https://raw.githubusercontent.com/divar-ir/DarkRoom/master/Sources/DarkRoom/DarkRoom.docc/Resources/DarkRoomLogo.png"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.authors            = { "Kiarash Vosough" => "vosough.k@gmail.com" }
  s.social_media_url   = "https://github.com/kiarashvosough1999"

  s.swift_versions = ['5.0']
  s.ios.deployment_target = '13.0'

  s.source        = { :git => "https://github.com/divar-ir/DarkRoom.git", :tag => s.version }
  s.source_files  = ["Sources/**/*.swift"]

  s.frameworks  = ["Foundation", "AVFoundation", "UIKit", "Combine"]

end