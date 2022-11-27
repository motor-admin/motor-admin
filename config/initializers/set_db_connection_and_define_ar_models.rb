# frozen_string_literal: true

Rails.configuration.to_prepare do
  Motor::ApplicationController.include(Module.new do
    extend ActiveSupport::Concern

    included do
      prepend_before_action :set_db_connection_and_define_ar_models
    end

    def set_db_connection_and_define_ar_models
      Motor::DefineConnectionClasses.call
    end
  end)

  Motor::DataController.include(Module.new do
    extend ActiveSupport::Concern

    included do
      prepend_before_action :maybe_set_db_connection_and_define_ar_models
    end

    def maybe_set_db_connection_and_define_ar_models
      return if Motor::DefineConnectionClasses.already_defined?

      Motor::DefineConnectionClasses.call
    end
  end)
end
