# frozen_string_literal: true

module PrismChecker
  class ReportBuilder
    def initialize(root, colorizer)
      @root = root
      @colorizer = colorizer
    end

    def build
      report(@root, 0, nil)
    end

    private

    def padding(level)
      '  ' * level
    end

    def key_padding(key)
      return '' if key.to_s.length.zero?

      ' ' * (key.to_s.length + 2)
    end

    def status_padding(node)
      ' ' * (node.status.length + 2)
    end

    def report(node, level, key)
      return @colorizer.colorize("#{node.status}: #{format_error_message(node, level, key)}", :failure) if node.failure?
      return @colorizer.colorize(node.status, :detail) unless node.success?

      case node
      when Node::Array
        report_array(node, level, key)
      when Node::Hash
        report_hash(node, level, key)
      else
        @colorizer.colorize(node.status, :success)
      end
    end

    def report_array(node, level, key)
      result = +@colorizer.colorize("[\n", :white)

      node.children.each do |child|
        result << "#{padding(level + 1)}#{report(child, level + 1, key)}\n"
      end

      result << @colorizer.colorize("#{padding(level)}]", :white)
    end

    def report_hash(node, level, _key)
      result = +@colorizer.colorize("{\n", :white)
      result << children_report(node, level)
      result << @colorizer.colorize("#{padding(level)}}", :white)
    end

    def children_report(node, level)
      node.children.map do |child_key, child|
        key_str = @colorizer.colorize("#{padding(level + 1)}#{child_key}:", :white)
        "#{key_str} #{report(child, level + 1, child_key)}\n"
      end.join
    end

    def format_error_message(node, level, key)
      message = node.error.message
      message.lines.map.with_index do |line, idx|
        if idx.zero?
          line
        else
          "#{padding(level)}#{status_padding(node)}#{key_padding(key)}#{line}"
        end
      end.join
    end
  end
end
