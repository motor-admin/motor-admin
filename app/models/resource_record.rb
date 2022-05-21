# frozen_string_literal: true

class ResourceRecord < ApplicationRecord
  self.abstract_class = true
  self.inheritance_column = nil

  CREATE_TIMESTAMP_COLUMNS = %w[inserted_at].freeze
  UPDATE_TIMESTAMP_COLUMNS = %w[edited_at].freeze

  def self.timestamp_attributes_for_create
    super + CREATE_TIMESTAMP_COLUMNS
  end

  def self.timestamp_attributes_for_update
    super + UPDATE_TIMESTAMP_COLUMNS
  end
end
