module Searchable
  extend ActiveSupport::Concern
  SEARCH_PARAMETER = {}.freeze
  class_methods do
    define_method :process_query do |params|
      model_param = self::SEARCH_PARAMETER || {}
      param = params[self.name.underscore]
      condition = self.where('')
      return condition unless param && model_param

      arel = self.arel_table

      if model_param[:like]
        like_condition = param.permit(model_param[:like]).to_h
        condition = like_condition.reduce(condition) do |c, value|
          c.where(arel[value.first].matches("%#{value.second}%"))
        end
      end

      if model_param[:exact]
        exact_condition = param.permit(model_param[:exact]).to_h
        condition = exact_condition.reduce(condition) do |c, value|
          operation = value.second.is_a?(Array) ? :in : :eq
          c.where(arel[value.first].send(operation, value.second))
        end
      end

      if model_param[:range]
        range_condition = param.permit(model_param[:range].map {|v| [v, %i(from to)]}.to_h).to_h
        condition = range_condition.reduce(condition) do |c, value|
          c = c.where(arel[value.first].gteq(value.second[:from])) if value.second[:from]
          c = c.where(arel[value.first].lteq(value.second[:to])) if value.second[:to]

          c
        end
      end

      condition
    end
  end
end