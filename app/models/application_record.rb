class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  include Searchable

  def self.fillable_attributes
    raise 'Method not defined'
  end

  def updatable_attributes
    raise 'Method not defined'
  end

  def as_json(options = {})
    except = options[:except] || []
    options[:except] = except + %i[discarded_at updated_at]
    super(options)
  end
end
