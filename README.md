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