require "stringio"
require "dockerfiroonga/command"

class CommandTest < Test::Unit::TestCase
  def setup
    @command = Dockerfiroonga::Command.new
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
      @output.each_line.first.start_with?("FROM ")
    end
  end
end
