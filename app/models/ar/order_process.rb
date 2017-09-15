# frozen_string_literal: true

module AR
  class OrderProcess < ActiveRecord::Base
    attr_accessor :commands
  end
end
