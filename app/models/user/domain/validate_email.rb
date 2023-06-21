module User
  module Domain
    class ValidateEmail
      def self.validate!(email:, user_repository:)
        raise Errors::ValidationError, 'E-mail already in use!' unless user_repository.find_by_email(email).nil?
      end
    end
  end
end
