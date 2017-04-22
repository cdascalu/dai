defmodule FIB.Comparer do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def compute(pid, sub_pid, a, b) do
    GenServer.call(pid, {:sub, a, b, sub_pid})
  end

  def handle_call({:sub, a, b, sub_pid}, _from, state) do
    diff = FIB.Substractor.compute(sub_pid, a, b)
    sgn = case diff do
      v when v > 0 -> 1
      v when v < 0 -> -1
      0 -> 0
    end
    {:reply, sgn, state}
  end

  def handle_call(request, from, state) do
    super(request, from, state)
  end

  def handle_cast(request, state) do
    super(request, state)
  end
end