module Dockerfiroonga
  class Command
    def self.run
      new.run
    end

    def initialize
    end

    def run
      puts <<-END_OF_FILE
FROM ubuntu
MAINTAINER Masafumi Yokoyama <yokoyama@clear-code.com>
RUN apt-get -y install software-properties-common
RUN add-apt-repository -y universe
RUN add-apt-repository -y ppa:groonga/ppa
RUN apt-get update
RUN apt-get -y install groonga
CMD ["groonga", "--version"]
      END_OF_FILE
    end
  end
end
