module IsCognitoUser
  extend ActiveSupport::Concern

  class_methods do
    def create_from_cognito_sub(sub)
      user = self.find_by(sub: sub) || self.new(sub: sub)
      user.update_from_cognito

      user
    end

    def create_from_cognito_username(username)
      user = self.find_by(username: username) || self.new(username: username)
      user.update_from_cognito

      user
    end
  end

  included do |base|
    attr_accessor :update_cognito
    after_create :save_to_cognito

    define_method :update_from_cognito do
      if username
        hash = cognito.get(username)
      elsif sub
        hash = cognito.get_by_sub(sub)
      else
        raise 'cannot get user without username or sub'
      end
      params = updatable_attributes + [:sub]
      params << :username unless persisted?

      @need_cognito_update = false
      update(ActionController::Parameters.new(hash).permit(params))

      self
    end

    def update(*args)
      return super(*args) unless update_cognito
      attr = update_to_cognito(*args) if update_cognito
      super(attr)
    end

    private

    define_method :cognito do
      @cognito ||= CognitoUser.new(base.name.to_s.downcase)
    end

    def save_to_cognito
      cognito.create(attributes.with_indifferent_access) if @update_cognito
    end

    def update_to_cognito(params = nil)
      cognito.update(username, params || attributes.with_indifferent_access) if @update_cognito
    end
  end
end