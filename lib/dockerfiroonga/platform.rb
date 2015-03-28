module Dockerfiroonga
  module Platform
    module_function
    def self.new(name)
      os, version = name.split(/:/)
      begin
        require "dockerfiroonga/platform/#{os}"
      rescue LoadError
        raise ArgumentError, "Invalid name: <#{name}>"
      end
      const_get(os.capitalize).new(version)
    end
  end
end
