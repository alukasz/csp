defmodule CSP.NQueens do
  def solve(size) do
    place([], 1, size, Tuple.duplicate(nil, size))
  end

  defp do_solve([h | t], col, size, rows) do
    with true <- valid?(t, h),
         true <- not_finished?(col, size),
         true <- place([h | t], col, size, rows)
    do
      true
    else
      false -> false # ?
      # :finished -> IO.inspect board; false
      :finished -> false
    end
  end

  def not_finished?(col, size) when col <= size, do: true
  def not_finished?(_, _), do: :finished

  defp place(board, col, size, rows) do
    Enum.any? 1..size, fn row ->
      do_solve([{row, col} | board], col + 1, size, [row | rows])
    end
  end

  defp valid?([], _), do: true
  defp valid?([{row, column} | _], {new_row, new_column})
    when row == new_row or column == new_column, do: false
  defp valid?([{row, column} | _], {new_row, new_column})
    when abs(row - new_row) == abs(column - new_column), do: false
  defp valid?([_ | tail], queen_position), do: valid?(tail, queen_position)
end
