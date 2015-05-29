require "stringio"
require "dockerfiroonga/command"

class CommandTest < Test::Unit::TestCase
  def setup
    @platform_name = "ubuntu"
    @command = Dockerfiroonga::Command.new([@platform_name])
    @stdout_string = ""
    @stderr_string = ""
    stdout_io = StringIO.new(@stdout_string)
    stderr_io = StringIO.new(@stderr_string)
    $stdout = stdout_io
    $stderr = stderr_io
  end

  def teardown
    $stdout = STDOUT
    $stderr = STDERR
  end

  def test_run
    @command.run
    assert do
      @stdout_string.lines.first.start_with?("FROM #{@platform_name}")
    end
  end

  def test_ubuntu
    @command.run
    assert_equal(<<-END_OF_FILE, @stdout_string)
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

  def test_rroonga
    @command = Dockerfiroonga::Command.new([@platform_name, "rroonga"])
    @command.run
    assert_equal(<<-END_OF_FILE, @stdout_string)
FROM ubuntu
MAINTAINER Masafumi Yokoyama <yokoyama@clear-code.com>
RUN apt-get -y install software-properties-common
RUN add-apt-repository -y universe
RUN add-apt-repository -y ppa:groonga/ppa
RUN apt-get update
RUN apt-get -y install groonga

RUN apt-get -y install libgroonga-dev
RUN apt-get -y install ruby-dev
RUN apt-get -y install make
RUN gem install rroonga

CMD ["groonga", "--version"]
    END_OF_FILE
  end

  class DebianWheezyTest < self
    def setup
      super
      @platform_name = "debian:wheezy"
    end

    def test_groonga
      @command = Dockerfiroonga::Command.new([@platform_name, "groonga"])
      @command.run
      assert_equal(<<-END_OF_FILE, @stdout_string)
FROM debian:wheezy
MAINTAINER Masafumi Yokoyama <yokoyama@clear-code.com>
RUN echo "deb http://packages.groonga.org/debian/ wheezy main" >/etc/apt/sources.list.d/groonga.list
RUN echo "deb-src http://packages.groonga.org/debian/ wheezy main" >>/etc/apt/sources.list.d/groonga.list
RUN apt-get update
RUN apt-get install -y --allow-unauthenticated groonga-keyring
RUN apt-get update
RUN apt-get install -y -V groonga

CMD ["groonga", "--version"]
      END_OF_FILE
    end

    def test_rroonga
      @command = Dockerfiroonga::Command.new([@platform_name, "rroonga"])
      @command.run
      assert_equal(<<-END_OF_FILE, @stdout_string)
FROM debian:wheezy
MAINTAINER Masafumi Yokoyama <yokoyama@clear-code.com>
RUN echo "deb http://packages.groonga.org/debian/ wheezy main" >/etc/apt/sources.list.d/groonga.list
RUN echo "deb-src http://packages.groonga.org/debian/ wheezy main" >>/etc/apt/sources.list.d/groonga.list
RUN apt-get update
RUN apt-get install -y --allow-unauthenticated groonga-keyring
RUN apt-get update
RUN apt-get install -y -V groonga

RUN apt-get install -y -V libgroonga-dev
RUN apt-get install -y -V ruby-dev
RUN apt-get install -y -V build-essential
RUN gem install rroonga

CMD ["groonga", "--version"]
      END_OF_FILE
    end
  end

  class DebianJessieTest < self
    def setup
      super
      @platform_name = "debian:jessie"
    end

    def test_groonga
      @command = Dockerfiroonga::Command.new([@platform_name, "groonga"])
      @command.run
      assert_equal(<<-END_OF_FILE, @stdout_string)
FROM debian:jessie
MAINTAINER Masafumi Yokoyama <yokoyama@clear-code.com>
RUN echo "deb http://packages.groonga.org/debian/ jessie main" >/etc/apt/sources.list.d/groonga.list
RUN echo "deb-src http://packages.groonga.org/debian/ jessie main" >>/etc/apt/sources.list.d/groonga.list
RUN apt-get update
RUN apt-get install -y --allow-unauthenticated groonga-keyring
RUN apt-get update
RUN apt-get install -y -V groonga

CMD ["groonga", "--version"]
      END_OF_FILE
    end
  end

  class DebianSidTest < self
    def setup
      super
      @platform_name = "debian:sid"
    end

    def test_groonga
      @command = Dockerfiroonga::Command.new([@platform_name, "groonga"])
      @command.run
      version = "5.0.0"
      assert_equal(<<-END_OF_FILE, @stdout_string)
FROM debian:sid
MAINTAINER Masafumi Yokoyama <yokoyama@clear-code.com>
RUN apt-get update
RUN apt-get install -y -V  wget tar build-essential zlib1g-dev liblzo2-dev libmsgpack-dev libzmq-dev libevent-dev libmecab-dev
RUN wget http://packages.groonga.org/source/groonga/groonga-#{version}.tar.gz
RUN tar xvzf groonga-#{version}.tar.gz
RUN cd groonga-#{version}/                            && \
    ./configure --prefix=/usr/local                   && \
    make -j$(grep '^processor' /proc/cpuinfo | wc -l) && \
    make install

CMD ["groonga", "--version"]
      END_OF_FILE
    end

    def test_rroonga
      @command = Dockerfiroonga::Command.new([@platform_name, "rroonga"])
      @command.run
      version = "5.0.0"
      assert_equal(<<-END_OF_FILE, @stdout_string)
FROM debian:sid
MAINTAINER Masafumi Yokoyama <yokoyama@clear-code.com>
RUN apt-get update
RUN apt-get install -y -V  wget tar build-essential zlib1g-dev liblzo2-dev libmsgpack-dev libzmq-dev libevent-dev libmecab-dev
RUN wget http://packages.groonga.org/source/groonga/groonga-#{version}.tar.gz
RUN tar xvzf groonga-#{version}.tar.gz
RUN cd groonga-#{version}/                            && \
    ./configure --prefix=/usr/local                   && \
    make -j$(grep '^processor' /proc/cpuinfo | wc -l) && \
    make install

RUN apt-get -y install libgroonga-dev
RUN apt-get -y install ruby-dev
RUN gem install rroonga

CMD ["groonga", "--version"]
      END_OF_FILE
    end
  end

  class CentosTest < self
    def setup
      super
      @platform_name = "centos"
    end

    def test_groonga
      @command = Dockerfiroonga::Command.new([@platform_name, "groonga"])
      @command.run
      assert_equal(<<-END_OF_FILE, @stdout_string)
FROM centos
MAINTAINER Masafumi Yokoyama <yokoyama@clear-code.com>
RUN rpm -ivh http://packages.groonga.org/centos/groonga-release-1.1.0-1.noarch.rpm
RUN yum makecache
RUN yum install -y groonga

CMD ["groonga", "--version"]
      END_OF_FILE
    end

    def test_rroonga
      @command = Dockerfiroonga::Command.new([@platform_name, "rroonga"])
      @command.run
      assert_equal(<<-END_OF_FILE, @stdout_string)
FROM centos
MAINTAINER Masafumi Yokoyama <yokoyama@clear-code.com>
RUN rpm -ivh http://packages.groonga.org/centos/groonga-release-1.1.0-1.noarch.rpm
RUN yum makecache
RUN yum install -y groonga

RUN yum install -y groonga-devel
RUN yum install -y ruby-devel
RUN yum install -y make gcc zlib-devel openssl-devel
RUN gem install rdoc
RUN gem install rroonga

CMD ["groonga", "--version"]
      END_OF_FILE
    end

    def test_mroonga_centos6
      @platform_name = "centos:6"
      @command = Dockerfiroonga::Command.new([@platform_name, "mroonga"])
      @command.run
      assert_equal(<<-END_OF_FILE, @stdout_string)
FROM centos:6
MAINTAINER Masafumi Yokoyama <yokoyama@clear-code.com>
RUN rpm -ivh http://packages.groonga.org/centos/groonga-release-1.1.0-1.noarch.rpm
RUN yum makecache
RUN yum install -y groonga

RUN yum install -y http://repo.mysql.com/mysql-community-release-el6-5.noarch.rpm
RUN yum makecache
RUN yum install -y mysql-community-server
RUN /sbin/service mysqld start
RUN yum install -y mysql-community-mroonga

CMD ["groonga", "--version"]
      END_OF_FILE
    end

    def test_mroonga_centos5
      @platform_name = "centos:5"
      @command = Dockerfiroonga::Command.new([@platform_name, "mroonga"])
      @command.run
      assert_equal(<<-END_OF_FILE, @stdout_string)
FROM centos:5
MAINTAINER Masafumi Yokoyama <yokoyama@clear-code.com>
RUN rpm -ivh http://packages.groonga.org/centos/groonga-release-1.1.0-1.noarch.rpm
RUN yum makecache
RUN yum install -y groonga

RUN yum install -y mysql55-mysql-server
RUN /sbin/service mysql55-mysqld start
RUN yum install -y mysql55-mroonga

CMD ["groonga", "--version"]
      END_OF_FILE
    end
  end

  def test_no_argument
    assert_raise SystemExit do
      Dockerfiroonga::Command.new([])
    end
    assert do
      @stdout_string.start_with?("Usage: ")
    end
  end

  def test_help_option_short
    assert_raise SystemExit do
      Dockerfiroonga::Command.new(["-h"])
    end
    assert do
      @stdout_string.start_with?("Usage: ")
    end
  end

  def test_help_option_long
    assert_raise SystemExit do
      Dockerfiroonga::Command.new(["--help"])
    end
    assert do
      @stdout_string.start_with?("Usage: ")
    end
  end

  def test_maintainer_option
    @command = Dockerfiroonga::Command.new([
                                             "--maintainer=Me",
                                             @platform_name,
                                           ])
    @command.run
    assert_equal("MAINTAINER Me\n", @stdout_string.lines[1])
  end

  def test_not_supported_platform
    assert_raise SystemExit do
      Dockerfiroonga::Command.new(["firefox"])
    end
    assert_equal("This platform is not supported yet: <firefox>\n",
                 @stderr_string.lines[0])
    assert do
      @stderr_string.lines[1].start_with?("Usage: ")
    end
  end

  def test_not_supported_xroonga
    assert_raise SystemExit do
      Dockerfiroonga::Command.new([@platform_name, "xxxroonga"])
    end
    assert_equal("This Xroonga is not supported yet: <xxxroonga>\n",
                 @stderr_string.lines[0])
    assert do
      @stderr_string.lines[1].start_with?("Usage: ")
    end
  end
end
