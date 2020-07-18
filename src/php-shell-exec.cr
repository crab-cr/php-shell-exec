# TODO: Write documentation for `Php::Shell::Exec`
module Iom::Php::ShellExec
  VERSION = "0.1.0"

  def self.shell_exec(
    cmd : String,
    args : Array(String)? = nil,
    env : Process::Env? = nil,
    clear_env : Bool = false,
    shell = false
  )
    stdout = IO::Memory.new
    stderr = IO::Memory.new
    process = Process.new(cmd, args: args, output: stdout, error: stderr, shell: shell, clear_env: clear_env)
    status = process.wait
    Result.new cmd, args, status.exit_code, stdout.to_s, stderr.to_s, clear_env
  end

  struct Result
    property exit_code : Int32
    property cmd : String
    property stdout : String
    property stderr : String
    property args : Array(String) | Nil
    property clear_env : Bool

    def initialize(@cmd, @args, @exit_code, @stdout, @stderr, @clear_env)
    end
  end
end
