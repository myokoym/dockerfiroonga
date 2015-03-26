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
end
