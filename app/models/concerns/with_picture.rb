module WithPicture
  extend ActiveSupport::Concern

  included do
    has_one_attached :picture
    default_scope { with_attached_picture }

    def picture_url
      picture.attached? ? picture_blob.service_url : ''
    end

    def as_json(options = {})
      super options.merge(methods: :picture_url)
    end
  end
end
