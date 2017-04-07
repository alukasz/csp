defmodule CSP.NQueens do
  alias CSP.Counter

  def solve(size) do
    place([], 1, 1, size)
  end

  defp solve([h | t], col, size) do
    Counter.increment(:calls)

    valid?(h, t)
      and (col <= size || Counter.increment(:solutions); true)
      and place([h | t], col, 1, size)
  end

  defp place(_board, _col, row, size) when row > size, do: false
  defp place(board, col, row, size) do
      solve([{row, col} | board], col + 1, size)
      place(board, col, row + 1, size)
  end

  defp valid?(_, []), do: true
  defp valid?({new_row, new_column}, [{row, column} | _])
    when row == new_row or column == new_column, do: false
  defp valid?({new_row, new_column}, [{row, column} | _])
    when abs(row - new_row) == abs(column - new_column), do: false
  defp valid?(queen_position, [_ | tail]), do: valid?(queen_position, tail)
end
