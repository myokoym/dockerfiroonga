module Dockerfiroonga
  module Platform
    module_function
    def self.new(name)
      begin
        require "dockerfiroonga/platform/#{name}"
      rescue LoadError
        raise ArgumentError, "Invalid name: <#{name}>"
      end
      const_get(name.capitalize).new
    end
  end
end
