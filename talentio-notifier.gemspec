require_relative 'lib/talentio/notifier/version'

Gem::Specification.new do |spec|
  spec.name          = "talentio-notifier"
  spec.version       = Talentio::Notifier::VERSION
  spec.authors       = ["pyama86"]
  spec.email         = ["pyama@pepabo.com"]

  spec.summary       = %q{nofity command for talentio.}
  spec.description   = %q{nofity command for talentio.}
  spec.homepage      = "https://github.com/pyama86/talentio-notifier"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency "thor"
  spec.add_dependency "faraday"
  spec.add_dependency 'slack-api'
  spec.add_dependency 'slack-ruby-client'
  spec.add_dependency "holiday_jp"
end
