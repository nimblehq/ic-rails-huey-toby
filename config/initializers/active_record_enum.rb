module ActiveRecord
  module Enum
    class EnumType < Type::Value
      def assert_valid_value(value)
        nil if value.present? && !mapping.key?(value) && !mapping.value?(value)
      end
    end
  end
end
