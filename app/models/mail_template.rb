class MailTemplate < ApplicationRecord
  include Discard::Model
  include Searchable

  INPUT_PARAMETER = %i[mail_sender_id mail_subject mail_cc mail_bcc mail_body].freeze
  SEARCH_PARAMETER = {
    exact: %i[mail_sender_id],
    like: %i[mail_subject mail_cc mail_bcc mail_body]
  }.freeze

  belongs_to :mail_sender
end