defmodule FIB.Server do
  use GenServer

  ## Client API

  @doc """
  Starts the registry with the given `name`.
  """
  def start_link(name) do
    GenServer.start_link(__MODULE__, :ok, name: name)
  end
  
  def solve(server, k) do
    # k + 3
    GenServer.call(server, {:solve, k})
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:solve, k}, _from, data) do
    {:reply, k+3, data}
  end

end