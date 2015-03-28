require "dockerfiroonga/platform/base"

module Dockerfiroonga
  module Platform
    class DebianWheezy
      include Base

      def installation_groonga
        codename = "wheezy"

        <<-END_OF_INSTALLATION
RUN echo "deb http://packages.groonga.org/debian/ #{codename} main" >/etc/apt/sources.list.d/groonga.list
RUN echo "deb-src http://packages.groonga.org/debian/ #{codename} main" >>/etc/apt/sources.list.d/groonga.list
RUN apt-get update
RUN apt-get install -y --allow-unauthenticated groonga-keyring
RUN apt-get update
RUN apt-get install -y -V groonga
        END_OF_INSTALLATION
      end

      def installation_rroonga
        <<-END_OF_INSTALLATION
#{installation_groonga}
RUN apt-get install -y -V libgroonga-dev
RUN apt-get install -y -V ruby-dev
RUN apt-get install -y -V build-essential
RUN gem install rroonga
        END_OF_INSTALLATION
      end
    end
  end
end
