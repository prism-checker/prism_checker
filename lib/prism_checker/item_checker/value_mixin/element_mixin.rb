# frozen_string_literal: true

module PrismChecker
  module ItemChecker
    module ValueMixin
      module ElementValue2
        def value(element)
          element.text
        end
      end
    end
  end
end
