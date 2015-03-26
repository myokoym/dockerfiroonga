require "dockerfiroonga/platform/base"

module Dockerfiroonga
  module Platform
    class DebianSid
      include Base

      def installation_groonga(version="5.0.0")
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

      def installation_rroonga
        <<-END_OF_INSTALLATION
#{installation_groonga}
RUN export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
RUN export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
RUN apt-get -y install ruby ruby-dev
RUN gem install rroonga
        END_OF_INSTALLATION
      end
    end
  end
end
