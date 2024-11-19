module WithStatus
  extend ActiveSupport::Concern

  included do
    enum status: {draft: "draft".freeze, published: "published".freeze}
  end
end