defmodule CSP.NQueens.ForwardChecking do
  import CSP.NQueens.Shared

  alias CSP.Counter

  def solve(size, heuristic), do: place([], 0, 0, size, create_state(size), heuristic)
  def solve([h | t], col, size, state, heuristic) do
    Counter.increment(:calls)

    valid?(h, t)
    and (col < size || Counter.increment(:solutions); true)
    and place([h | t], col, 0, size, state, heuristic)
  end

  defp place(_board, _col, row, size, _state, _heuristic) when row == size, do: false
  defp place(board, col, row, size, state, heuristic)
    when elem(state, col * size + row) == false do
    place(board, col, row + 1, size, state, heuristic)
  end
  defp place(board, col, row, size, state, heuristic) do
    next_col = heuristic.(board, col, row, size, state)
    solve([{row, col} | board], next_col, size, update_state(state, col, row, size), heuristic)
    place(board, col, row + 1, size, state, heuristic)
  end
end
