# frozen_string_literal: true

module PrismChecker
  module ItemChecker
    module PageMixin
      module PageValue2
        def value(page)
          page.find('body')&.text || page.text
        end
      end
    end
  end
end
