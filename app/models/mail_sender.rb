class MailSender < ApplicationRecord
  include Discard::Model
  include Searchable

  INPUT_PARAMETER = %i[sender_name sender_mail].freeze
  SEARCH_PARAMETER = {
    like: %i[sender_name]
  }.freeze

  has_many :mail_templates
end
