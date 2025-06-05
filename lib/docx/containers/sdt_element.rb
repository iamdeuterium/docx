require 'docx/containers/text_run'
require 'docx/containers/container'

module Docx
  module Elements
    module Containers
      class SdtElement
        include Container
        include Elements::Element

        def self.tag
          'std'
        end

        def alias
          at_xpath('./w:sdtPr/w:alias/@w:val')&.value
        end

        def text=(content)
          if text_runs.size == 1
            text_runs.first.text = content
          elsif text_runs.size == 0
            new_r = TextRun.create_within_node(content_node)
            new_r.text = content
          else
            replaced = false

            text_runs.each do |r|
              unless r.text.to_s.empty?
                if replaced
                  r.node.remove
                else
                  r.text = content
                  replaced = true
                end
              end
            end
          end
        end

        def to_s
          text_runs.map(&:text).join('')
        end

        def text_runs
          content_node.xpath('.//w:r').map { |r_node| Containers::TextRun.new(r_node) }
        end

        def content_node
          @node.at_xpath('./w:sdtContent')
        end

        def initialize(node)
          @node = node
          @properties_tag = 'sdtPr'
        end

        alias_method :text, :to_s
      end
    end
  end
end
