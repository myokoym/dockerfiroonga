require "dockerfiroonga/platform"

module Dockerfiroonga
  class Command
    def self.run(arguments)
      new(arguments).run
    end

    def initialize(arguments)
      if arguments.empty?
        $stdout.puts(<<-END_OF_USAGE)
Usage: dockerfiroonga PLATFORM [Xroonga]
  PLATFORM:
    * debian:sid (.tar.gz)
    * ubuntu (PPA)
    * centos (yum)
  Xroonga:
    * groonga (default)
    * rroonga
        END_OF_USAGE
        exit(true)
      end
      @platform_name = arguments[0]
      @platform = Platform.new(@platform_name)
      @_roonga = arguments[1] || "groonga"
      unless @platform.respond_to?("installation_#{@_roonga}")
        raise ArgumentError, "Not supported yet: <#{@_roonga}>"
      end
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
