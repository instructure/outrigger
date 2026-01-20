# frozen_string_literal: true

describe Outrigger::Railtie do
  it "provides a railtie_name" do
    expect(described_class.railtie_name).to eq "taggable_migrations"
  end
end
