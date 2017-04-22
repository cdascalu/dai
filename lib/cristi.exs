defmodule Adder do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def compute(pid, a, b) do
    GenServer.call(pid, {:sum, a, b})
  end

  def handle_call({:sum, a, b}, _from, state) do
    {:reply, a + b, state}
  end

  def handle_call(request, from, state) do
    super(request, from, state)
  end

  def handle_cast(request, state) do
    super(request, state)
  end

end

defmodule Modulator do
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

defmodule Substractor do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def compute(pid, a, b) do
    GenServer.call(pid, {:sub, a, b})
  end

  def handle_call({:sub, a, b}, _from, state) do
    {:reply, a - b, state}
  end

  def handle_call(request, from, state) do
    super(request, from, state)
  end

  def handle_cast(request, state) do
    super(request, state)
  end
end

defmodule Comparer do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def compute(pid, sub_pid, a, b) do
    GenServer.call(pid, {:sub, a, b, sub_pid})
  end

  def handle_call({:sub, a, b, sub_pid}, _from, state) do
    diff = Substractor.compute(sub_pid, a, b)
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

defmodule FileReader do
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

defmodule Stack do 
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

defmodule CachingFibonnaci do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      worker(Stack, [[], [name: StackPID]]),
      worker(Adder, [[name: AdderPID]]),
      worker(Modulator, [[name: ModulatorPID]]),
      worker(Substractor, [[name: SubstractorPID]]),
      worker(Comparer, [[name: ComparerPID]])
    ]

    supervise(children, strategy: :one_for_one)
  end

  def populate_list(value, max, modulo) do
    if Comparer.compute(ComparerPID, SubstractorPID, value, max) == -1 do
      if Comparer.compute(ComparerPID, SubstractorPID, value, 0) == 0 do
        Stack.push(StackPID, 1)
      else
        if Comparer.compute(ComparerPID, SubstractorPID, value, 1) == 0 do
          Stack.push(StackPID, 1)
        else
          third = Stack.at(StackPID, Substractor.compute(SubstractorPID, value, 2))
          second = Stack.at(StackPID, Substractor.compute(SubstractorPID, value, 1))
          current = Adder.compute(AdderPID, third, second)
          current = Modulator.compute(ModulatorPID, current, modulo)

          if Comparer.compute(ComparerPID, SubstractorPID, second, 1) == 0 
          and Comparer.compute(ComparerPID, SubstractorPID, current, 1) == 0 do
            Stack.pop(StackPID) 
            value = max
          else
            Stack.push(StackPID, current)
          end
        end
      end
      populate_list(Adder.compute(AdderPID, value, 1), max, modulo)
    end
  end

  def get_nth(value, modulo) do
    size = Stack.size(StackPID)
    populate_list(size, value, modulo)
    size = Stack.size(StackPID)
    value = Substractor.compute(SubstractorPID, value, 1)
    index = Modulator.compute(ModulatorPID, value, size)
    Stack.at(StackPID, index)
  end
end

defmodule AppSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(FileReader, ['C:\\Users\\botezatu\\Desktop\\mihai.txt.txt', [name: FileReaderPID]]),
      worker(CachingFibonnaci, [[name: FibonnaciPID]]),
    ]

    supervise(children, strategy: :one_for_one)
  end

  def do_final() do 
    k = FileReader.read_number(FileReaderPID)
    CachingFibonnaci.get_nth(10, 13)
  end
end

{:ok, supervisor_pid} = AppSupervisor.start_link()
IO.puts AppSupervisor.do_final()