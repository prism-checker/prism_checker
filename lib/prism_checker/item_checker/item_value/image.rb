# frozen_string_literal: true

module PrismChecker
  module ItemChecker
    module ItemValue
      module Image
        def value(image)
          image['src']
        end
      end
    end
  end
end
