require_relative 'lib/talentio/notifier/version'

Gem::Specification.new do |spec|
  spec.name          = 'talentio-notifier'
  spec.version       = Talentio::Notifier::VERSION
  spec.authors       = ['pyama86']
  spec.email         = ['www.kazu.com@gmail.com']

  spec.summary       = 'nofity command for talentio.'
  spec.description   = 'nofity command for talentio.'
  spec.homepage      = 'https://github.com/pyama86/talentio-notifier'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 3.1.0')

  spec.metadata['homepage_uri'] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.add_dependency 'activesupport'
  spec.add_dependency 'faraday'
  spec.add_dependency 'holiday_jp'
  spec.add_dependency 'ruby-openai'
  spec.add_dependency 'slack-ruby-client'
  spec.add_dependency 'thor'
end
