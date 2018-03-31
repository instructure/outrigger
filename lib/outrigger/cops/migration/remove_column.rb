require 'rubocop'
require_relative '../helpers/migration_tags'

module RuboCop
  module Cop
    module Migration
      class RemoveColumn < Cop
        include RuboCop::Cop::Migration::Tags
        MSG = '`remove_column` needs to be in a postdeploy migration'.freeze

        def check_migration
          return unless banned_tags.empty?
          add_offense(migration_node,
                      message: 'No BannedTags have been defined in the RuboCop configuration for' \
                               ' Migration/RemoveColumn.',
                      severity: :warning)
        end

        def on_def(node)
          return unless in_migration?
          method_name, *_args = *node
          @current_def = method_name
        end

        def on_defs(node)
          return unless in_migration?
          _receiver, method_name, *_args = *node
          @current_def = method_name
        end

        def on_send(node)
          return unless in_migration?
          _receiver, method_name, *_args = *node
          add_offense(node, message: MSG, severity: :warning) if remove_column_in_predeploy?(method_name)
        end

        private

        def remove_column_in_predeploy?(method_name)
          method_name == :remove_column &&
            @current_def == :up &&
            banned_tag?
        end

        def banned_tag?
          !(tags & banned_tags).empty?
        end

        def banned_tags
          cop_config['BannedTags'].to_a.map(&:to_sym)
        end
      end
    end
  end
end
