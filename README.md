# FIB

The project contains a supervisor that launches a server. The server exposes a dummy solve method that receives a number as an input and returns input + 3.

Install elixir form: http://elixir-lang.org/install.html

```sh
mix compile
```
```sh
iex -S mix
```
```sh
FIB.Supervisor.start_link
```
```sh
FIB.Server.solve(FIB.Server, 3)
```