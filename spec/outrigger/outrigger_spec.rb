# frozen_string_literal: true

describe Outrigger do
  describe 'filter' do
    it 'returns a proc that tests migrations' do
      filter = described_class.filter(:predeploy)

      expect(filter.call(PreDeployMigration)).to eq(true)
    end

    it 'accepts multiple tags' do
      filter = described_class.filter(:predeploy, :postdeploy)

      expect(filter.call(MultiMigration)).to eq(true)
      expect(filter.call(PreDeployMigration)).to eq(false)
    end
  end
end
