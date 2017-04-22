defmodule FIB.Stack do 
  use GenServer

  def start_link(list \\ [], opts \\ []) do
    GenServer.start_link(__MODULE__, list, opts)
  end

  def at(pid, index) do
    GenServer.call(pid, {:at, index})
  end

  def push(pid, value) do
    GenServer.cast(pid, {:push, value})
  end

  def pop(pid) do
    GenServer.call(pid, :pop)
  end

  def size(pid) do
    GenServer.call(pid, :size)
  end

  def handle_call({:at, index}, _from, list) do
    position = length(list) - index - 1
    {:reply, Enum.at(list, position), list}
  end

  def handle_call(:size, _from, list) do
    {:reply, length(list), list}
  end

  def handle_call(:pop, _from, [value | list]) do
    {:reply, value, list}
  end

  def handle_cast({:push, value}, list) do
    {:noreply, [value | list]}
  end
end