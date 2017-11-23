# frozen_string_literal: true
module Infrastructure
  module Repositories
    class WriteRepo < ROM::Repository[:write_repo]
      commands :create
    end
  end
end
