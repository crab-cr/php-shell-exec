# php-shell-exec

Looking for PHP's shell_exec, but found yourself inside a crystal codebase? Look no further!

[Docs on Crystal's Process module](https://crystal-lang.org/api/0.35.1/Process.html)

This shard exposes a function that is a wrapper around crystal's process module that will feel more like PHP's shell_exec function.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     php-shell-exec:
       github: iomcr/php-shell-exec
   ```

2. Run `shards install`

## Usage

```crystal
require "php-shell-exec"

# PHP: $result_string = shell_exec($cmd = "ls -la")

# important difference: you have to seperate the args
# from the command.
result = Iom::Php::ShellExec.shell_exec("ls", ["-la"])

puts result.exit_code # Int32, 0 means success
puts result.cmd # String, the original cmd
puts result.stdout # String, the stdout output
puts result.stderr # String, the stderr output
puts result.args # Array(String) | Nil, the original args

# more optional args:
result = Iom::Php::ShellExec.shell_exec(
  cmd: "ls",
  args: ["-la"],
  clear_env: )
```

What does `clear_env : Bool` do?
```
$ DB_PASSWORD=bongodb crystal eval 'require "../iomcr/php-shell-exec/src/php-shell-exec"; pp Iom::Php::ShellExec.shell_exec("printenv", ["DB_PASSWORD"], clear_env: false)'
Iom::Php::ShellExec::Result(
 @args=["DB_PASSWORD"],
 @clear_env=false,
 @cmd="printenv",
 @exit_code=0,
 @stderr="",
 @stdout="bongodb\n")
```
```
DB_PASSWORD=bongodb crystal eval 'require "../iomcr/php-shell-exec/src/php-shell-exec"; pp Iom::Php::ShellExec.shell_exec("printenv", ["DB_PASSWORD"], clear_env: true)'
Iom::Php::ShellExec::Result(
 @args=["DB_PASSWORD"],
 @clear_env=true,
 @cmd="printenv",
 @exit_code=1,
 @stderr="",
 @stdout="")
 ```

Very cool, `clear_env : Bool` prevents the child process from reading the current process's ENV. I thought this was important to note because it wasn't in the docs.

If you wanted to save the results as JSON
```crystal
require "json"
require "php-shell-exec"

# monkey patch JSON::Serializable onto the Result struct:
struct Iom::Php::ShellExec::Result
  include JSON::Serializable
end

p json = Iom::Php::ShellExec.shell_exec("ls", ["la"]).to_json
# "{\"exit_code\":2,\"cmd\":\"ls\",\"stdout\":\"\",\"stderr\":\"ls: cannot access 'la': No such file or directory\\n\",\"args\":[\"la\"],\"clear_env\":false}"

# put in your DB as TEXT, JSON, and/or JSONB, etc, then retrieve later:

p Iom::Php::ShellExec::Result.from_json(json)
# Iom::Php::ShellExec::Result(@exit_code=2, @cmd="ls", @stdout="", @stderr="ls: cannot access 'la': No such file or directory\n", @args=["la"], @clear_env=false)
```
## Development

Pull Requests, additional docs, and tests welcome!

## Contributing

1. Fork it (<https://github.com/iomcr/php-shell-exec/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [IOM](https://github.com/iomcr) - creator and maintainer
