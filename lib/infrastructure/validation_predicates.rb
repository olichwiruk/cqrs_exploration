# frozen_string_literal: true

module Infrastructure
  module ValidationPredicates
    include Dry::Logic::Predicates

    VALID_EMAIL_REGEX =
      /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

    predicate(:email?) do |value|
      !VALID_EMAIL_REGEX.match(value).nil?
    end
  end
end
