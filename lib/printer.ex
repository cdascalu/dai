defmodule FIB.Printer do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def print(pid, msg) do
    GenServer.call(pid, {:msg, msg})
  end

  def handle_call({:msg, msg}, _from, state) do
    {:reply, "result: " <> to_string(msg), state}
  end

  def handle_call(request, from, state) do
    super(request, from, state)
  end

  def handle_cast(request, state) do
    super(request, state)
  end

end