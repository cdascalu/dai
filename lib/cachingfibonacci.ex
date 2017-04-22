defmodule FIB.CachingFibonacci do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      worker(FIB.Stack, [[], [name: StackPID]]),
      worker(FIB.Adder, [[name: AdderPID]]),
      worker(FIB.Modulator, [[name: ModulatorPID]]),
      worker(FIB.Substractor, [[name: SubstractorPID]]),
      worker(FIB.Comparer, [[name: ComparerPID]])
    ]

    supervise(children, strategy: :one_for_one)
  end

  def populate_list(value, max, modulo) do
    if FIB.Comparer.compute(ComparerPID, SubstractorPID, value, max) == -1 do
      if FIB.Comparer.compute(ComparerPID, SubstractorPID, value, 0) == 0 do
        FIB.Stack.push(StackPID, 1)
      else
        if FIB.Comparer.compute(ComparerPID, SubstractorPID, value, 1) == 0 do
          FIB.Stack.push(StackPID, 1)
        else
          third = FIB.Stack.at(StackPID, FIB.Substractor.compute(SubstractorPID, value, 2))
          second = FIB.Stack.at(StackPID, FIB.Substractor.compute(SubstractorPID, value, 1))
          current = FIB.Adder.compute(AdderPID, third, second)
          current = FIB.Modulator.compute(ModulatorPID, current, modulo)

          if FIB.Comparer.compute(ComparerPID, SubstractorPID, second, 1) == 0 
          and FIB.Comparer.compute(ComparerPID, SubstractorPID, current, 1) == 0 do
            FIB.Stack.pop(StackPID) 
            value = max
          else
            FIB.Stack.push(StackPID, current)
          end
        end
      end
      populate_list(FIB.Adder.compute(AdderPID, value, 1), max, modulo)
    end
  end

  def get_nth(value, modulo) do
    size = FIB.Stack.size(StackPID)
    populate_list(size, value, modulo)
    size = FIB.Stack.size(StackPID)
    value = FIB.Substractor.compute(SubstractorPID, value, 1)
    index = FIB.Modulator.compute(ModulatorPID, value, size)
    FIB.Stack.at(StackPID, index)
  end
end
