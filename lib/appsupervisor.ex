defmodule FIB.AppSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(FIB.FileReader, ['/Users/cristi/projects/dai/fibonacci.in', [name: FileReaderPID]]),
      worker(FIB.CachingFibonacci, [[name: FibonacciPID]]),
    ]

    supervise(children, [strategy: :one_for_one])
  end

  def do_final() do 
    k = FIB.FileReader.read_number(FileReaderPID)
    FIB.CachingFibonacci.get_nth(k, 13)
  end
end