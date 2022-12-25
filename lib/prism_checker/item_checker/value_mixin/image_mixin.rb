# frozen_string_literal: true

module PrismChecker
  module ItemChecker
    module ValueMixin
      module ImageValue
        def value(image)
          image['src']
        end
      end
    end
  end
end
