# frozen_string_literal: true

require 'active_record' unless defined? ActiveRecord

require 'outrigger/taggable'
require 'outrigger/taggable_proxy'

require 'outrigger/railtie' if defined? Rails::Railtie

module Outrigger
  def self.filter(*tags)
    tags = tags.flatten.map(&:to_sym)
    proc { |migration| (tags - migration.tags).empty? }
  end
end
