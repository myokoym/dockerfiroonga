module Dockerfiroonga
  module Platform
    class Ubuntu
      def initialize
      end

      def installation
        <<-END_OF_INSTALLATION
RUN apt-get -y install software-properties-common
RUN add-apt-repository -y universe
RUN add-apt-repository -y ppa:groonga/ppa
RUN apt-get update
RUN apt-get -y install groonga
        END_OF_INSTALLATION
      end
    end
  end
end
