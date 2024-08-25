# frozen_string_literal: true

module Caniuse
  class RubyVersion
    def initialize(version, url, sha256)
      @version = version
      @url = url
      @sha256 = sha256
    end

    def download!
      return if File.exist?("cache/ruby-#{@version}")

      File.write("cache/#{@version}.archive", Net::HTTP.get(URI(@url)))
      `tar xf cache/#{@version}.archive -C cache`
      File.delete("cache/#{@version}.archive")
    end

    def run_rdoc!
      options = RDoc::Options.new
      options.root = "cache/ruby-#{@version}"
      options.files = ["cache/ruby-#{@version}"]
      options.op_dir = "#{__dir__}/../../docs/#{@version}"
      options.generator = RDocYAMLGenerator

      options.template = "irrelevant"

      rdoc = RDoc::RDoc.new
      rdoc.document(options)
    end
  end
end
