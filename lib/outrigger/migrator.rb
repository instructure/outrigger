# frozen_string_literal: true

module Outrigger
  module Migrator
    def runnable
      result = super
      return result unless Outrigger.ordered

      # re-order according to configuration
      result.sort_by! { |m| [Outrigger.ordered[m.tags.first] || 0, m.version] }
      result.reverse! if down?
      result
    end
  end
end
