module Task
  module Domain
    class TaskRepository
      def self.store
        raise 'This should be implemented in concrete class'
      end

      def self.count
        raise 'This should be implemented in concrete class'
      end

      def self.find
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
