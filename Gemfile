source ENV["GEM_SOURCE"] || "https://rubygems.org"

# Specify your gem's dependencies in choria-mcorpc-support.gemspec
gemspec

group :development, :test do
  gem "diplomat", "~> 2"
  gem "etcdv3"
  gem "jgrep", ">= 1.5.0"
  # jgrep 1.6 needs Ruby 3.3 and jgrep 1.5 still sets JSON.create_id, which json 3 removed
  gem "json", "< 3" if RUBY_VERSION < "3.3"
  gem "json-schema-rspec"
  gem "listen", "~> 3"
  gem "mcollective-test"
  gem "mocha", "~> 0.12.2"
  # openvox 9 needs Ruby 3.2, so Ruby 3.1 tests against openvox 8
  gem "openvox", ">= 8", "< 10"
  gem "rake", ">= 12.3.3"
  gem "rdoc"
  gem "rspec", "~> 3.9.0"
  gem "rubocop", "1.6.1"
  gem "semantic_puppet"
  gem "webmock"
  gem "yard"
  gem "google-protobuf", "~> 3.25.0"
end
