
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "sql_enum/version"

Gem::Specification.new do |spec|
  spec.name          = "sql_enum"
  spec.version       = SqlEnum::VERSION
  spec.authors       = ["Fletcher Fowler"]
  spec.email         = ["fletch@fzf.me"]

  spec.summary       = %q{Enable using native sql enums}
  spec.homepage      = "https://github.com/1debit/sql_enum"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", "~> 5.0"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
