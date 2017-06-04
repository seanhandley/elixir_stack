defmodule Stack.Server do
  use GenServer

  # API Calls

  def start_link(stash_pid) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, stash_pid, name: __MODULE__)
  end

  def pop do
    {status, el} = GenServer.call __MODULE__, :pop
    case status do
      :ok -> el
      :error -> raise "Stack is empty"
    end
  end

  def push(el) do
    GenServer.cast __MODULE__, {:push, el}
  end

  # GenServer Calls 

  def init(stash_pid) do
    current_stack = Stack.Stash.get_value stash_pid
    { :ok, {current_stack, stash_pid}}
  end    

  def handle_call(:pop, _from, {current_stack, stash_pid}) when current_stack == [] do
    { :reply, {:error, nil}, {[], stash_pid} }
  end            

  def handle_call(:pop, _from, {current_stack, stash_pid}) do
    [head|tail] = current_stack      
    { :reply, {:ok, head}, {tail, stash_pid} }
  end

  def handle_cast({:push, el}, {current_stack, stash_pid}) do
    { :noreply, {[el|current_stack], stash_pid} }
  end

  def terminate(_reason, {current_stack, stash_pid}) do
    Stack.Stash.save_value stash_pid, current_stack
  end

end
