Gem::Specification.new do |s|
  s.name         = 'ichiban'
  s.version      = '1.0.5'
  s.date         = '2012-11-29'
  s.summary      = 'Ichiban'
  s.description  = 'Static website compiler with advanced feature, including watcher script.'
  s.authors      = ['Jarrett Colby']
  s.email        = 'jarrett@madebyhq.com'
  s.files        = Dir.glob('lib/**/*') + Dir.glob('empty_project/**/*')
  s.executables  = ['ichiban']
  s.homepage     = 'https://github.com/jarrett/ichiban'
  
  s.add_runtime_dependency 'erubis'
  s.add_runtime_dependency 'sass'
  s.add_runtime_dependency 'listen'
  s.add_runtime_dependency 'activesupport'
  
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'turn'
  s.add_development_dependency 'lorax'
  
  s.post_install_message = File.read(File.join(File.dirname(__FILE__), 'post_install_message.txt'))
end