# FIB

The project contains a supervisor that launches a server. The server exposes a dummy solve method that receives a number as an input and returns input + 3.

Install elixir form: http://elixir-lang.org/install.html

Make sure you set the right path for the input file in lib/appsupervisor.ex

```sh
mix compile
```
```sh
iex -S mix
```
```sh
FIB.AppSupervisor.start_link
```
```sh
FIB.AppSupervisor.do_final()
```

How to see if the supervisor is working:

1. modify FileReader to return 3 / number:

```elixir
{:reply, 3 / String.to_integer(hd(list)), stream}
```

Now if we set 0 as our input FIB.FileReader.read_number will crash

2. Open the console using the iex command

3. Test to see that if a process is created and then it crashes you can't use it anymore

```sh
{:ok, pid} = FIB.FileReader.start_link('/Users/cristi/projects/dai/fibonacci.in')
FIB.FileReader.read_number(pid) # non-zero value in the input file.
FIB.FileReader.read_number(pid) # zero value -> it crashes.
FIB.FileReader.read_number(pid) # "undefined function pid". You can't use it anymore
```

4. Use the supervisor using the same logic as above to see that you don't need to start the process again

```sh
FIB.AppSupervisor.start_link
FIB.FileReader.read_number(FileReaderPID) # non-zero value
FIB.FileReader.read_number(FileReaderPID) # zero value -> it crashes
FIB.FileReader.read_number(FileReaderPID) # non-zero value -> it works (the supervisor works)
```