defmodule Panda.AST do
  use GenFSM.Behaviour

  @myname :fsm

  def start_link do
    :gen_fsm.start_link({ :local, @myname }, __MODULE__, [], [])
    :gen_fsm.send_event(@myname, :start)
  end

  def next_character(next_char) do
    :gen_fsm.send_event(@myname, { :next_char, next_char })
  end

  #OTP Specfic

  def init(_) do
    { :ok, :start, [] }
  end

  # START
  def start(:start, _inital_state) do
    report("Beginning", 1)
    { :next_state, :state_1, 1 }
  end

  # STATE1
  def state_1({ :next_char, next_char }, current_state) do
    [new_state_atom, new_state_number] = case next_char do
      "a" -> [:state_2, 2]
      "b" -> [:state_1, 1]
    end
    report(current_state, new_state_number)
    { :next_state, new_state_atom, new_state_number }
  end

  # STATE2
  def state_2({ :next_char, next_char}, current_state) do
    [new_state_atom, new_state_number] = case next_char do
      "a" -> [:state_3, 3]
      "b" -> [:state_2, 2]
    end
    report(current_state, new_state_number)
    { :next_state, new_state_atom, new_state_number }
  end

  # STATE3
  def state_3({ :next_char, next_char }, current_state) do
    [new_state_atom, new_state_number] = case next_char do
      "a" -> [:final_state, "Final"]
      "b" -> [:state_2, 2]
    end
    report(current_state, new_state_number)
    { :next_state, new_state_atom, new_state_number }
  end

  # FinalState
  def final_state({ :next_char, _next_char }, current_state) do
    report(current_state, 1)
    { :next_state, :state_1, 1 }
  end

  # Helpers
  defp report(old_state, new_state) do
    IO.puts "Leaving #{inspect old_state} and entering #{inspect new_state}"
  end
end
