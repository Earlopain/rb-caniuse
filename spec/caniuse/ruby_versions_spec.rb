# frozen_string_literal: true

RSpec.describe Caniuse::RubyVersions do
  before do
    stub_request(:get, described_class::DATA_URL)
      .to_return(body: File.read("./fixtures/releases.yml"))
  end

  it "returns correct versions" do
    expected = File.read("./fixtures/releases_filtered.yml")
    yml = Psych.safe_load(expected, permitted_classes: [Symbol])
    expect(described_class.data).to eq(yml)
  end
end
