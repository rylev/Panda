defmodule Panda.Stack do
  use GenServer.Behaviour

  def start_link(initial_stack) do
    :gen_server.start_link({ :local, :stack }, __MODULE__, initial_stack, [])
  end

  def pop do
    :gen_server.call(:stack, :pop)
  end

  def push(new_elem) do
    :gen_server.cast(:stack, { :push, new_elem })
  end

  def init(initial_stack) do
    { :ok, initial_stack }
  end

  def handle_call(:pop, _from, [head|tail]) do
    { :reply, head, tail }
  end

  def handle_cast({ :push, new_elem }, current_stack) do
    { :noreply, [new_elem|current_stack] }
  end
end
