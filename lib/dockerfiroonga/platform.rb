module Dockerfiroonga
  module Platform
    module_function
    def self.new(name)
      require_name = name.gsub(/:/, "_")
      begin
        require "dockerfiroonga/platform/#{require_name}"
      rescue LoadError
        raise ArgumentError, "Invalid name: <#{name}>"
      end
      class_name = name.split(/:/).collect {|w| w.capitalize}.join
      const_get(class_name).new
    end
  end
end
