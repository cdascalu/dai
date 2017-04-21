defmodule FIB.Sum do
  @doc """
  Starts a new bucket.
  """
  def start_link do
    # Agent.start_link(fn -> %{} end)
    Agent.start_link(fn -> %{} end)
  end

  def compute(a, b) do
    a + b
  end

end