# frozen_string_literal: true

module PrismChecker
  module ItemChecker
    module ItemValue
      module Page
        def value(page)
          page.find('body')&.text || page.text
        end
      end
    end
  end
end
