# frozen_string_literal: true

class AbsenceExpectation
  attr_reader :delay

  def initialize(delay)
    @delay = delay
  end
end
