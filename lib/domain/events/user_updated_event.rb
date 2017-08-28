# frozen_string_literal: true

require 'infrastructure/types'

class UserUpdatedEvent < Dry::Struct
  include Types

  attribute :aggregate_uid, Types::String
  attribute :name, Types::String
  attribute :email, Types::String

  def values
    val = instance_values
    val.delete('aggregate_uid')
    val.delete_if { |_, v| v.nil? }
    val
  end
end
