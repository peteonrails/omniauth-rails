# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name 		= "omniauth-rails"
  s.summary 	= "Common Rails controllers for OmniAuth."
  s.description = "A Rails Engine that implements common controllers, routes, and callback endpoints needed by OmniAuth as an engine. Now you can install and configure Omniauth by convention, with zero code."
  s.version 	= OmniAuth::Rails::VERSION
  s.platform 	= Gem::Platform::Ruby
  s.authors 	= ['Peter Jackson', 'Michael Bleigh']
  s.email 		= ['pete@intridea.com', 'mbleigh@intridea.com']
  s.homepage    = ['https://github.com/intridea/omniauth/wiki']

  s.required_rubygems_version = "> 1.3.6"
  s.add_dependency "activesupport" , "~> 3.1.0"
  s.add_dependency "rails"         , "~> 3.1.0"
  

  s.files = `git ls-files`.split("\n")
  s.executables = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'

end