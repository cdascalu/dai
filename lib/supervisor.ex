defmodule FIB.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(FIB.Server, [FIB.Server])
    ]

    supervise(children, strategy: :one_for_one)
  end
end