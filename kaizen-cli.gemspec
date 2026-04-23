# frozen_string_literal: true

require_relative 'lib/kaizen/version'

Gem::Specification.new do |spec|
  spec.name          = 'kaizen-cli'
  spec.version       = Kaizen::VERSION
  spec.authors       = ['Sorted.']
  spec.email         = []

  spec.summary       = 'Small improvements, every day. The compound interest of discipline.'
  spec.description   = 'kaizen is a terminal tool for recording daily small improvements. Track what you fixed, cleaned, or simplified. See your streak, weekly log, and all-time stats. No cloud. No sync. Just a local record of getting better.'
  spec.homepage      = 'https://github.com/YumaKakuya/kaizen'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 3.0.0'

  spec.files         = Dir.glob('{bin,lib}/**/*') + %w[README.md LICENSE kaizen-cli.gemspec]
  spec.bindir        = 'bin'
  spec.executables   = ['kaizen']
  spec.require_paths = ['lib']

  # No runtime dependencies — stdlib only
end
