class Hit < Ohm::Model
  attribute :page
  attribute :checksum
  attribute :updated_at

  index :page
  unique :page
end
