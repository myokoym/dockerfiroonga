require "stringio"
require "dockerfiroonga/command"

class CommandTest < Test::Unit::TestCase
  def setup
    @platform_name = "ubuntu"
    @command = Dockerfiroonga::Command.new([@platform_name])
    @output = ""
    io = StringIO.new(@output)
    $stdout = io
  end

  def teardown
    $stdout = STDOUT
  end

  def test_run
    @command.run
    assert do
      @output.each_line.first.start_with?("FROM #{@platform_name}")
    end
  end

  def test_ubuntu
    @command.run
    assert_equal(<<-END_OF_FILE, @output)
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
    assert_equal(<<-END_OF_FILE, @output)
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

  class DebianSidTest < self
    def setup
      super
      @platform_name = "debian:sid"
    end

    def test_groonga
      @command = Dockerfiroonga::Command.new([@platform_name, "groonga"])
      @command.run
      version = "5.0.0"
      assert_equal(<<-END_OF_FILE, @output)
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
      assert_equal(<<-END_OF_FILE, @output)
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
      assert_equal(<<-END_OF_FILE, @output)
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
      assert_equal(<<-END_OF_FILE, @output)
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
  end

  def test_not_supported_xroonga
    assert_raise ArgumentError do
      Dockerfiroonga::Command.new([@platform_name, "xxxroonga"])
    end
  end
end
