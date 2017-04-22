defmodule FIB.FileReader do
  use GenServer

  def start_link(path, opts \\ []) do
    stream = path |> File.stream!
    GenServer.start_link(__MODULE__, stream, opts)
  end

  def read_number(pid) do
    GenServer.call(pid, :read)
  end

  def handle_call(:read, _from, stream) do
    list = stream |> Stream.map(&String.trim_trailing/1)
                  |> Enum.to_list
    {:reply, String.to_integer(hd(list)), stream}
  end

end
