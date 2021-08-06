# frozen_string_literal: true

class ResourceRecord < ApplicationRecord
  self.abstract_class = true
  self.inheritance_column = nil
end
