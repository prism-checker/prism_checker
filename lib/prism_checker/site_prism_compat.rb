# frozen_string_literal: true

module PrismChecker
  # site_prism 6 nests its errors under SitePrism::Error, while 5 keeps them
  # at the top level. The gem supports both, so the class is resolved on first
  # use rather than at load time: site_prism is required by the host suite,
  # not by prism_checker itself.
  module SitePrismCompat
    def self.timeout_error
      @timeout_error ||= if SitePrism.const_defined?(:Error, false) && SitePrism::Error.const_defined?(:TimeoutError, false)
                           SitePrism::Error::TimeoutError
                         else
                           SitePrism::TimeoutError
                         end
    end
  end
end
