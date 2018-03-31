require 'rubocop'
require_relative '../helpers/migration_tags'

module RuboCop
  module Cop
    module Migration
      class Tagged < Cop
        include RuboCop::Cop::Migration::Tags

        private

        def check_migration
          ensure_allowed_tags
          ensure_tagged
          check_bad_tags
        end

        def ensure_allowed_tags
          return unless allowed_tags.empty?
          add_offense(migration_node,
                      message: 'No AllowedTags have been defined in the RuboCop configuration for' \
                               ' Migration/Tagged.',
                      severity: :warning)
        end

        def ensure_tagged
          return unless tags.empty?
          add_offense(migration_node,
                      message: "All migrations require a tag from #{allowed_tags}.",
                      severity: :warning)
        end

        def check_bad_tags
          tags.each do |tag|
            next if allowed_tags.include?(tag)
            add_offense(tag_node,
                        message: "Tags may only be one of #{allowed_tags}. Bad tag: #{tag}",
                        severity: :warning)
          end
        end

        def allowed_tags
          cop_config['AllowedTags'].to_a.map(&:to_sym)
        end
      end
    end
  end
end
