require "optparse"
require "dockerfiroonga/platform"
require "dockerfiroonga/version"

module Dockerfiroonga
  class Command
    USAGE = <<-END_OF_USAGE
Usage: dockerfiroonga [OPTIONS] PLATFORM [Xroonga]
  PLATFORM:
    * debian[:wheezy] (APT)
    * debian:XXX (.tar.gz)
    * ubuntu (PPA)
    * centos (yum)
  Xroonga:
    * groonga (default)
    * rroonga
    END_OF_USAGE

    def self.run(arguments)
      new(arguments).run
    end

    def initialize(arguments)
      @options = parse_options(arguments)

      @platform_name = arguments[0]
      begin
        @platform = Platform.new(@platform_name)
      rescue ArgumentError
        $stderr.puts("This platform is not supported yet: <#{@platform_name}>")
        $stderr.puts(USAGE)
        exit(false)
      end

      @_roonga = arguments[1] || "groonga"
      unless @platform.respond_to?("installation_#{@_roonga}")
        $stderr.puts("This Xroonga is not supported yet: <#{@_roonga}>")
        $stderr.puts(USAGE)
        exit(false)
      end

      @maintainer = @options[:maintainer] ||
                      "Masafumi Yokoyama <yokoyama@clear-code.com>"
    end

    def run
      puts <<-END_OF_FILE
FROM #{@platform_name}
MAINTAINER #{@maintainer}
#{@platform.__send__("installation_#{@_roonga}")}
CMD ["groonga", "--version"]
      END_OF_FILE
    end

    private
    def parse_options(arguments)
      options = {}

      parser = OptionParser.new(<<-END_OF_BANNER)
#{USAGE.chomp}
  OPTIONS:
      END_OF_BANNER

      parser.version = VERSION

      parser.on("-h", "--help", "Show usage") do |boolean|
        puts(parser.help)
        exit(true)
      end
      parser.on("--maintainer=NAME", "Set maintainer") do |name|
        options[:maintainer] = name
      end
      parser.parse!(arguments)

      if arguments.empty?
        puts(parser.help)
        exit(true)
      end

      options
    end
  end
end
