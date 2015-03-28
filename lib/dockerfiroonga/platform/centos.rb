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

      def installation_mroonga
        case @os_version
        when "centos5", "5"
          <<-END_OF_INSTALLATION
#{installation_groonga}
#{installation_mroonga_mysql55.chomp}
          END_OF_INSTALLATION
        when "centos6", "6"
          <<-END_OF_INSTALLATION
#{installation_groonga}
#{installation_mroonga_mysql_community.chomp}
          END_OF_INSTALLATION
        else
          raise ArgumentError, "Not supported: <#{@os_version}>"
        end
      end

      private
      def installation_mroonga_mysql55
        <<-END_OF_INSTALLATION
RUN yum install -y mysql55-mysql-server
RUN /sbin/service mysql55-mysqld start
RUN yum install -y mysql55-mroonga
        END_OF_INSTALLATION
      end

      def installation_mroonga_mysql_community
        centos_version = @os_version[-1]

        <<-END_OF_INSTALLATION
RUN yum install -y http://repo.mysql.com/mysql-community-release-el#{centos_version}-5.noarch.rpm
RUN yum makecache
RUN yum install -y mysql-community-server
RUN /sbin/service mysqld start
RUN yum install -y mysql-community-mroonga
        END_OF_INSTALLATION
      end
    end
  end
end
