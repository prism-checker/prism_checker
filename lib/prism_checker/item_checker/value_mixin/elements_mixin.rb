# frozen_string_literal: true

module PrismChecker
  module ItemChecker
    module ValueMixin
      module ElementsValue2
        def value(elements)
          elements.map(&:text).join(' ')
        end
      end
    end
  end
end
