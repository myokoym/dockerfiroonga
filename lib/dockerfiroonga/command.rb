require "dockerfiroonga/platform"

module Dockerfiroonga
  class Command
    def self.run(arguments)
      new(arguments).run
    end

    def initialize(arguments)
      @platform_name = arguments[0]
      @platform = Platform.new(@platform_name)
      @_roonga = arguments[1] || "groonga"
    end

    def run
      puts <<-END_OF_FILE
FROM #{@platform_name}
MAINTAINER Masafumi Yokoyama <yokoyama@clear-code.com>
#{@platform.__send__("installation_#{@_roonga}")}
CMD ["groonga", "--version"]
      END_OF_FILE
    end
  end
end
