# LuckyCart Framework - (c)2022 Lucky Cart

#
# Be sure to run `pod lib lint MoofFoundation.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
	s.name             = "LuckyCart"
	s.version          = "0.5.0"
	s.summary          = "LuckyCart framework for iOS/macOS"
	s.description      = <<-DESC
					LuckyCart provides the API to communicate with LuckyCart server
					   DESC
	s.homepage         = "http://www.luckycart.com"
	s.license          = 'MIT'
	s.author           = { "LuckyCart" => "vincent@oliveira.fr" }
	s.source           = { :git => "https://github.com/lucky-cart/lucky-cart-ios.git", :tag => s.version.to_s }
	
    s.social_media_url = 'https://twitter.com/LuckyCart'

	s.ios.deployment_target = '15'
    s.osx.deployment_target = '12'
    s.tvos.deployment_target = '15'
    s.watchos.deployment_target = '8'

	s.requires_arc = true

	s.source_files = 'LuckyCart/Sources/**/*.*'
end
