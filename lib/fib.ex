defmodule FIB do
  use Application

  def start(_type, _args) do
    FIB.AppSupervisor.start_link
  end
end