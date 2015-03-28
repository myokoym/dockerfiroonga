module Dockerfiroonga
  module Platform
    module Base
      def initialize(os_version=nil)
        @os_version = os_version
      end
    end
  end
end
