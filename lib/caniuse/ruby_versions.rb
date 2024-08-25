# frozen_string_literal: true

module Caniuse
  module RubyVersions
    DATA_URL = URI("https://raw.githubusercontent.com/ruby/www.ruby-lang.org/master/_data/releases.yml")

    module_function

    def fetch
      res = Net::HTTP.get_response(DATA_URL)
      raise StandardError, "Got status code #{res.code}: #{res.body}" unless res.code == "200"

      data = Psych.safe_load(res.body, permitted_classes: [Date])
      filter!(data)
      transform(data)
    end

    def filter!(data)
      # Ignore prereleases
      data.reject! { _1["version"] =~ /[a-zA-Z]/ }
      # Ignore anything below 2.1
      data.reject! { _1["version"] < "2.1" }
    end

    def transform(data)
      grouped = data.group_by { _1["version"].to_f }
      grouped.transform_values do |releases|
        release = releases.max_by { Gem::Version.new(_1["version"]) }
        {
          version: release["version"],
          url: release["url"]["xz"],
          sha256: release["sha256"]["xz"]
        }
      end
    end
  end
end
