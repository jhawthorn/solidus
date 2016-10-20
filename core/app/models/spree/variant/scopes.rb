module Spree
  class Variant < Spree::Base
    # FIXME: WARNING tested only under sqlite and postgresql
    scope :descend_by_popularity, -> {
      Spree::Deprecation.warn("descend_by_popularity is DEPRECATED. It has performance problems on stores with a large number of orders.")
      order("COALESCE((SELECT COUNT(*) FROM  #{LineItem.quoted_table_name} GROUP BY #{LineItem.quoted_table_name}.variant_id HAVING #{LineItem.quoted_table_name}.variant_id = #{Variant.quoted_table_name}.id), 0) DESC")
    }

    class << self
      # Returns variants that match a given option value
      #
      # @example Find by OptionType and OptionValue
      # product.variants.has_option(OptionType.find_by(name: 'shoe-size'), OptionValue.find_by(name: '8'))
      #
      # @example Find by names of option type and option value
      # product.variants.has_option('shoe-size', '8')
      def has_option(option_type, *option_values)
        if option_values.size > 1
          Spree::Deprecation.warn("has_option with more than two arguments is deprecated and always returns an empty set of records")
          return none
        end

        t_option_values_variant = OptionValuesVariant.arel_table
        t_option_value = OptionValue.arel_table
        t_option_type = OptionType.arel_table
        subquery = t_option_values_variant.project(Arel.star).where(t_option_values_variant[:variant_id].eq(arel_table[:id]))
        subquery = subquery.join(t_option_value).on(t_option_values_variant[:option_value_id].eq(t_option_value[:id]))
        subquery = subquery.join(t_option_type).on(t_option_value[:option_type_id].eq(t_option_type[:id]))

        option_type_conditions =
          case option_type
          when OptionType
            t_option_type[:id].eq(option_type.id)
          when String
            t_option_type[:name].eq(option_type)
          else
            t_option_type[:id].eq(option_type)
          end

        option_value = option_values[0]
        option_value_conditions =
          case option_value
          when OptionValue
            t_option_value[:id].eq(option_value.id)
          when String
            t_option_value[:name].eq(option_value)
          else
            t_option_value[:id].eq(option_value)
          end

        subquery = subquery.where(option_type_conditions)
        subquery = subquery.where(option_value_conditions)

        where(subquery.exists)
      end

      alias_method :has_options, :has_option
    end
  end
end
