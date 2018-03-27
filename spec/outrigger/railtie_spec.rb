require 'spec_helper'

describe Outrigger::Railtie do
  let(:subject) { Outrigger::Railtie }

  it 'provides a railtie_name' do
    expect(subject.railtie_name).to eq 'taggable_migrations'
  end
end
