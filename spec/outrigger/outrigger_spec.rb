# frozen_string_literal: true

describe Outrigger do
  describe "filter" do
    it "returns a proc that tests migrations" do
      filter = described_class.filter(:predeploy)

      expect(filter.call(PreDeployMigration)).to be(true)
    end

    it "accepts multiple tags" do
      filter = described_class.filter(:predeploy, :postdeploy)

      expect(filter.call(MultiMigration)).to be(true)
      expect(filter.call(PreDeployMigration)).to be(false)
    end
  end
end
