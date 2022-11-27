# frozen_string_literal: true

module Motor
  class Ability
    include CanCan::Ability

    CURRENT_USER_ID_KEY = 'current_user_id'
    CURRENT_USER_EMAIL_KEY = 'current_user_email'

    def initialize(admin_user, _request = nil)
      return if admin_user.nil?

      can :read, Motor::Tag
      can :read, Motor::NoteTag
      can :manage, Motor::Notification, recipient: admin_user
      can :manage, Motor::Reminder, author: admin_user

      admin_user.rules.each do |rule|
        subjects, actions, attributes, conditions =
          rule.values_at('subjects', 'actions', 'attributes', 'conditions')

        if attributes.present?
          can(actions.map(&:to_sym),
              normalize_subjects_argument(subjects),
              attributes.map(&:to_sym),
              normalize_conditions_argument(conditions, admin_user))
        else
          can(actions.map(&:to_sym),
              normalize_subjects_argument(subjects),
              normalize_conditions_argument(conditions, admin_user))
        end
      end
    end

    def normalize_subjects_argument(subjects)
      return [:all] if subjects == ['all']

      subjects.filter_map(&:safe_constantize)
    end

    # rubocop:disable Metrics/AbcSize
    def normalize_conditions_argument(conditions, admin_user)
      return {} if conditions.blank?

      conditions.each_with_object({}) do |condition, acc|
        key, value = condition.values_at('key', 'value')

        next if value.is_a?(Array) && value.blank?

        parts = key.split('.')

        parts.lazy.with_index.reduce(acc) do |key_acc, (part, index)|
          if index == parts.size - 1
            key_acc[part.to_sym] = normalize_condition_value(value, admin_user)

            key_acc
          else
            new_hash = {}

            key_acc[part.to_sym] = new_hash

            new_hash
          end
        end
      end
    end
    # rubocop:enable Metrics/AbcSize

    def normalize_condition_value(value, admin_user)
      Array.wrap(value).map do |val|
        case val
        when CURRENT_USER_ID_KEY
          admin_user.id
        when CURRENT_USER_EMAIL_KEY
          admin_user.email
        else
          val
        end
      end
    end
  end
end
