# frozen_string_literal: true

module Outrigger
  module TaggableProxy
    def self.included(_body)
      delegate :tags, to: :migration
    end
  end
end
