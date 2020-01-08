require 'active_record' unless defined? ActiveRecord

require 'outrigger/taggable'
require 'outrigger/taggable_proxy'

require 'outrigger/railtie' if defined? Rails::Railtie

module Outrigger
  def self.filter(*tags)
    tags = tags.flatten.map(&:to_sym)
    proc do |migration|
      begin
        # check if migration.tags have complete intersection with requested tags
        (tags - migration.tags).empty?
      rescue StandardError
        false
      end
    end
  end
end
