defmodule Practice.Factor do
  # find prime factorization of the number

  # https://kapeli.com/cheat_sheets/Elixir_Guards.docset/Contents/Resources/Documents/index
  # guard clause for bitstring. (wasn't sure if string == bitstring)
  def factor(x) when is_bitstring(x) do
    {num, _} = Integer.parse(x)
    factor(num, 2)
  end

  def factor(x) when is_integer(x) do
    factor(x, 2)
  end

  def factor(x, divisor) do
    # format into integer. division gives decimals
    x = trunc(x)
    divisor = trunc(divisor)

    cond do
      # no more possible
      x / divisor == 1 -> [divisor]
      rem(x, divisor) == 0 -> [divisor | factor(x / divisor, divisor)]
      true -> factor(x, divisor + 1)
    end
  end
end
