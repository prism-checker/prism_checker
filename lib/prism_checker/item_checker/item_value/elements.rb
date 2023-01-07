# frozen_string_literal: true

module PrismChecker
  module ItemChecker
    module ItemValue
      module Elements
        def value(elements)
          elements.map(&:text).join(' ')
        end
      end
    end
  end
end
