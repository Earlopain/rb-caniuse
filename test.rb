# frozen_string_literal: true

require_relative "lib/caniuse"

Caniuse::RubyVersions.fetch.each do |version|
  version.download!
  version.run_rdoc!
end
