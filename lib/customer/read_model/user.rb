# frozen_string_literal: true

module Customer
  module ReadModel
    class User < Disposable::Twin
      feature Changed

      property :id
      property :uid
      property :name
      property :email
    end
  end
end
