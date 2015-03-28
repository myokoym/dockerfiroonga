require "dockerfiroonga/platform/base"

module Dockerfiroonga
  module Platform
    class Debian
      include Base

      def initialize(os_version=nil)
        super
        @os_version ||= "wheezy"
      end

      def installation_groonga(version="5.0.0")
        case @os_version
        when "wheezy"
          installation_groonga_wheezy
        else
          installation_groonga_source(version)
        end
      end

      def installation_rroonga
        <<-END_OF_INSTALLATION
#{installation_groonga}
RUN export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
RUN export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
RUN apt-get -y install ruby ruby-dev
RUN gem install rroonga
        END_OF_INSTALLATION
      end

      def installation_mroonga(version="5.0.0")
        case @os_version
        when "wheezy"
          <<-END_OF_INSTALLATION
#{installation_groonga}
#{installation_mroonga_wheezy.chomp}
          END_OF_INSTALLATION
        else
          raise ArgumentError, "Not supported: <#{@os_version}>"
        end
      end

      private
      def installation_groonga_wheezy
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

      def installation_groonga_source(version)
        <<-END_OF_INSTALLATION
RUN apt-get update
RUN apt-get install -y -V  wget tar build-essential zlib1g-dev liblzo2-dev libmsgpack-dev libzmq-dev libevent-dev libmecab-dev
RUN wget http://packages.groonga.org/source/groonga/groonga-#{version}.tar.gz
RUN tar xvzf groonga-#{version}.tar.gz
RUN cd groonga-#{version}/                            && \
    ./configure --prefix=/usr/local                   && \
    make -j$(grep '^processor' /proc/cpuinfo | wc -l) && \
    make install
        END_OF_INSTALLATION
      end

      def installation_mroonga_wheezy
        <<-END_OF_INSTALLATION
RUN apt-get install -y -V mysql-server-mroonga
        END_OF_INSTALLATION
      end
    end
  end
end
