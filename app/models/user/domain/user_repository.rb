# frozen_string_literal: true

module User
  module Domain
    class UserRepository
      def self.store
        raise 'This should be implemented in concrete class'
      end

      def self.count
        raise 'This should be implemented in concrete class'
      end

      def self.find
        raise 'This should be implemented in concrete class'
      end

      def self.find_by_email
        raise 'This should be implemented in concrete class'
      end

      def self.next_id
        raise 'This should be implemented in concrete class'
      end

      def self.last
        raise 'This should be implemented in concrete class'
      end
    end
  end
end
