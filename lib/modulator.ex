defmodule FIB.Modulator do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def compute(pid, a, b) do
    GenServer.call(pid, {:mod, a, b})
  end

  def handle_call({:mod, a, b}, _from, state) do
    {:reply, rem(a, b), state}
  end

  def handle_call(request, from, state) do
    super(request, from, state)
  end

  def handle_cast(request, state) do
    super(request, state)
  end

end