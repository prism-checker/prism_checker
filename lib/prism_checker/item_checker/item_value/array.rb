# frozen_string_literal: true

module PrismChecker
  module ItemChecker
    module ItemValue
      module Array
        def value(elements)
          elements.map(&:to_s).join(' ')
        end
      end
    end
  end
end
