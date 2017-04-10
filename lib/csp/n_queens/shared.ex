defmodule CSP.NQueens.Shared do
  alias CSP.Counter

  def valid?(_, []), do: true
  def valid?({new_row, new_column}, [{row, column} | _])
    when row == new_row or column == new_column, do: false
  def valid?({new_row, new_column}, [{row, column} | _])
    when abs(row - new_row) == abs(column - new_column), do: false
  def valid?(queen_position, [_ | tail]), do: valid?(queen_position, tail)

  def create_state(size) do
    Tuple.duplicate(true, size * size)
  end

  def update_state(state, col, row, size) do
    remove_row(state, col, row, size)
    |> remove_nw(col - 1, row - 1, size) # delete?
    |> remove_se(col + 1, row + 1, size)
    |> remove_sw(col - 1, row + 1, size)
    |> remove_ne(col + 1, row - 1, size)
  end

  def remove_row(state, col, _row, size) when col >= size, do: state
  def remove_row(state, col, row, size) when elem(state, col * size + row) == false do
    remove_row(state, col + 1, row, size)
  end
  def remove_row(state, col, row, size) do
    remove_row(remove_move(state, col, row, size), col + 1, row, size)
  end

  def remove_nw(state, -1, _row, _size), do: state
  def remove_nw(state, _col, -1, _size), do: state
  def remove_nw(state, col, row, size) when elem(state, col * size + row) == false do
    remove_nw(state, col - 1, row - 1, size)
  end
  def remove_nw(state, col, row, size) do
    remove_nw(remove_move(state, col, row, size), col - 1, row - 1, size)
  end

  def remove_se(state, col, _row, size) when col >= size, do: state
  def remove_se(state, _col, row, size) when row >= size, do: state
  def remove_se(state, col, row, size) when elem(state, col * size + row) == false do
    remove_se(state, col + 1, row + 1, size)
  end
  def remove_se(state, col, row, size) do
    remove_se(remove_move(state, col, row, size), col + 1, row + 1, size)
  end

  def remove_sw(state, -1, _row, _size), do: state
  def remove_sw(state, _col, row, size) when row >= size, do: state
  def remove_sw(state, col, row, size) when elem(state, col * size + row) == false do
    remove_sw(state, col - 1, row + 1, size)
  end
  def remove_sw(state, col, row, size) do
      remove_sw(remove_move(state, col, row, size), col - 1, row + 1, size)
  end

  def remove_ne(state, col, _row, size) when col >= size, do: state
  def remove_ne(state, _col, -1, _size), do: state
  def remove_ne(state, col, row, size) when elem(state, col * size + row) == false do
    remove_ne(state, col + 1, row - 1, size)
  end
  def remove_ne(state, col, row, size) do
    remove_ne(remove_move(state, col, row, size), col + 1, row - 1, size)
  end

  def remove_move(state, col, row, size) do
    put_elem(state, col * size + row, false)
  end
end
