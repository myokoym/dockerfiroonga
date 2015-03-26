require "dockerfiroonga/platform/base"

module Dockerfiroonga
  module Platform
    class Centos
      include Base

      def installation_groonga
        <<-END_OF_INSTALLATION
RUN rpm -ivh http://packages.groonga.org/centos/groonga-release-1.1.0-1.noarch.rpm
RUN yum makecache
RUN yum install -y groonga
        END_OF_INSTALLATION
      end

      def installation_rroonga
        <<-END_OF_INSTALLATION
#{installation_groonga}
RUN yum install -y groonga-devel
RUN yum install -y ruby-devel
RUN yum install -y make gcc zlib-devel openssl-devel
RUN gem install rdoc
RUN gem install rroonga
        END_OF_INSTALLATION
      end
    end
  end
end
