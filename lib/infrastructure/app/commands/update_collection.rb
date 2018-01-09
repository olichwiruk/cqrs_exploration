# frozen_string_literal: true

class UpdateCollection < ROM::SQL::Commands::Update
  relation :order_lines
  register_as :update_collection

  def execute(tuples)
    to_be_updated, to_be_created = tuples.partition(&:id)
    to_be_deleted, to_be_updated = to_be_updated.partition { |ol| ol.quantity.zero? }

    to_be_deleted.each do |ol|
      relation.by_pk(ol.id).command(:delete).call
    end
    to_be_updated.each do |ol|
      relation.by_pk(ol.id).command(:update).call(ol)
    end
    relation.changeset(:create, to_be_created).commit
  end
end
