module RuboCop
  module Cop
    module Migration
      class Tagged < Cop
        def on_class(node)
          _name, superclass, body = *node
          if superclass == s(:const, s(:const, nil, :ActiveRecord), :Migration)
            check(node, body) if body
          end
        end

        private

        def s(name, *args)
          Parser::AST::Node.new(name, args)
        end

        def check(klass, node)
          tag_node = node.type == :begin && node.children.compact.find { |n| n.type == :send && n.to_a[1] == :tag }

          if allowed_tags.empty?
            add_offense(tag_node, :expression, "No allowed tags have been defined in the RuboCop configuration.")
          elsif tag_node
            add_offense(tag_node, :expression, "Tags may only be one of #{allowed_tags}.") unless allowed_tags.include? tag_node.children.last.to_a.last
          else
            add_offense(klass, :expression, "All migrations require a tag from #{allowed_tags}.")
          end
        end

        def allowed_tags
          cop_config["AllowedTags"].map(&:to_sym)
        end
      end
    end
  end
end
