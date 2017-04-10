defmodule CSP.NQueens.Heuristic do
  def first_empty(_board, col, _row, _size, _state) do
    col + 1
  end

  def most_constraints(board, col, row, size, state) do
    # :timer.sleep(200)
    count_invalid_moves(Tuple.duplicate(0, size), state, 0, size, size * size)
    |> most_constraints(board, 0, -1, 0, size)
    |> case do
         -1 -> size
         col -> col
       end
    # |> IO.inspect
    # col + 1
  end

  def most_constraints(free_space, board, size, index, max, size), do: index
  def most_constraints(free_space, board, counter, index, max, size) do
    constraints = elem(free_space, counter)
    # IO.inspect is_available(board, counter)
    case constraints > max && is_available(board, counter) do
      true -> most_constraints(free_space, board, counter + 1, counter, constraints, size)
      _    -> most_constraints(free_space, board, counter + 1, index, max, size)
    end
  end

  def is_available([], _), do: true
  def is_available([{_, col} | _], col), do: false
  def is_available([_ | tail], col) do
    is_available(tail, col)
  end

  def count_invalid_moves(free_space, _, size, _size, total) when size == total, do: free_space
  def count_invalid_moves(free_space, state, index, size, total) do
    case elem(state, index) do
      true ->
        count_invalid_moves(free_space, state, index + 1, size, total)
      false ->
        col = rem(index, size)
        current = elem(free_space, col)
        free_space = put_elem(free_space, col, current + 1)
        count_invalid_moves(free_space, state, index + 1, size, total)
    end
  end
end
