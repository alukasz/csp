defmodule CSP.NQueens.Backtracking do
  import CSP.NQueens.Shared

  alias CSP.Counter

  def solve(size, heuristic), do: place([], 0, 0, size, create_state(size))
  def solve([h | t], col, size, state) do
    Counter.increment(:calls)

    valid?(h, t)
    and (col < size || Counter.increment(:solutions); true)
    and place([h | t], col, 0, size, state)
  end

  defp place(_board, _col, row, size, _state) when row == size, do: false
  defp place(board, col, row, size, state) do
    solve([{row, col} | board], col + 1, size, update_state(state, col, row, size))
    place(board, col, row + 1, size, state)
  end
end
