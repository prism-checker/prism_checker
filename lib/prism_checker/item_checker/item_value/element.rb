# frozen_string_literal: true

module PrismChecker
  module ItemChecker
    module ItemValue
      module Element
        def value(element)
          element.text
        end
      end
    end
  end
end
