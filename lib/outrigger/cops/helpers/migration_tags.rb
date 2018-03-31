module RuboCop
  module Cop
    module Migration
      module Tags
        def on_class(node)
          _name, superclass, body = *node
          unless body && superclass && migration_class_node?(superclass)
            @in_migration = false
            return
          end
          @in_migration = true
          @migration_node = node
          @tag_node = find_tag_node(body)
          @tags = extract_tags(tag_node)
          check_migration
        end

        def check_migration
          # possibly define in your migration cop
        end

        def in_migration?
          @in_migration
        end

        def migration_node
          @migration_node
        end

        def tag_node
          @tag_node
        end

        def tags
          @tags || []
        end

        private

        def migration_class_node?(node)
          if node.type == :send # for tagged migrations, ex: ActiveRecord::Migration[5.0]
            node.children.first == migration_class_node
          else
            node == migration_class_node
          end
        end

        def migration_class_node
          s(:const, s(:const, nil, :ActiveRecord), :Migration)
        end

        def s(name, *args)
          Parser::AST::Node.new(name, args)
        end

        def extract_tags(tag_node)
          return [] unless tag_node
          tag_node.children.last.to_a.map do |tag|
            # Symbol check for `tag :predeploy` case
            # else for `tag [:predeploy, :dynamo]` case
            tag.is_a?(Symbol) ? tag : tag.to_a.last
          end
        end

        def find_tag_node(node)
          node.type == :begin && node.children.compact.find do |n|
            n.type == :send && n.to_a[1] == :tag
          end
        end
      end
    end
  end
end
