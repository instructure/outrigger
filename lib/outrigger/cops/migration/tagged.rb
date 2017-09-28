module RuboCop
  module Cop
    module Migration
      class Tagged < Cop
        def on_class(node)
          _name, superclass, body = *node
          return unless body && superclass == s(:const, s(:const, nil, :ActiveRecord), :Migration)
          check(node, body)
        end

        private

        def s(name, *args)
          Parser::AST::Node.new(name, args)
        end

        def check(klass, node)
          tag = tag_node(node)

          if allowed_tags.empty?
            add_offense(tag, :expression, 'No allowed tags have been defined in the RuboCop configuration.')
          elsif tag
            return if allowed_tags.include? tag.children.last.to_a.last
            add_offense(tag, :expression, "Tags may only be one of #{allowed_tags}.")
          else
            add_offense(klass, :expression, "All migrations require a tag from #{allowed_tags}.")
          end
        end

        def tag_node(node)
          node.type == :begin && node.children.compact.find do |n|
            n.type == :send && n.to_a[1] == :tag
          end
        end

        def allowed_tags
          cop_config['AllowedTags'].map(&:to_sym)
        end
      end
    end
  end
end
