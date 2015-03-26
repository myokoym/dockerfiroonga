require "dockerfiroonga/platform/base"

module Dockerfiroonga
  module Platform
    class Ubuntu
      include Base

      def installation
        installation_groonga
      end

      def installation_groonga
        <<-END_OF_INSTALLATION
RUN apt-get -y install software-properties-common
RUN add-apt-repository -y universe
RUN add-apt-repository -y ppa:groonga/ppa
RUN apt-get update
RUN apt-get -y install groonga
        END_OF_INSTALLATION
      end

      def installation_rroonga
        <<-END_OF_INSTALLATION
#{installation_groonga}
RUN apt-get -y install libgroonga-dev
RUN apt-get -y install ruby-dev
RUN apt-get -y install make
RUN gem install rroonga
        END_OF_INSTALLATION
      end
    end
  end
end
