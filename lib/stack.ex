defmodule Stack do
  use Application

  def start(_type, _args) do
    Application.get_env(:stack, :initial_stack)
    |> Stack.Supervisor.start_link
  end
end
