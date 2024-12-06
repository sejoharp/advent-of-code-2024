defmodule Day2 do
  @moduledoc false

  def read_input do
    input_path = "lib/day2_input.txt"

    case File.open(input_path, [:read]) do
      {:ok, file} ->
        lines =
          IO.stream(file, :line)
          |> Enum.to_list()
          |> Enum.map(fn line ->
            line
            |> (fn line -> String.replace(line, "\n", "") end).()
            |> (fn line -> String.split(line, " ") end).()
            |> Enum.map(fn string_numbers -> String.to_integer(string_numbers) end)
          end)

        File.close(file)
        lines

      {:error, reason} ->
        IO.puts("Failed to open file: #{reason}")
    end
  end

  def detect_sorting([first, second | _numbers]) when first < second do
    :increase
  end

  def detect_sorting([first, second | _numbers]) when first > second do
    :decrease
  end

  def detect_sorting([first, second | _numbers]) when first == second do
    :equal
  end

  def detect_state([first | numbers], sorting) when sorting == :increase do
    second = List.first(numbers)

    cond do
      second >= first + 1 and second <= first + 3 and length(numbers) == 1 -> :safe
      second >= first + 1 and second <= first + 3 -> detect_state(numbers, :increase)
      true -> :unsafe
    end
  end

  def detect_state([first | numbers], sorting) when sorting == :decrease do
    second = List.first(numbers)

    cond do
      second <= first - 1 and second >= first - 3 and length(numbers) == 1 -> :safe
      second <= first - 1 and second >= first - 3 -> detect_state(numbers, :decrease)
      true -> :unsafe
    end
  end

  def detect_state(_numbers, sorting) when sorting == :equal do
    :unsafe
  end

  def is_safe?(numbers) do
    sorting = detect_sorting(numbers)
    detect_state(numbers, sorting)
  end

  def count_safe_lists(number_lists) do
    safe_lists =
      Enum.filter(number_lists, fn number_list ->
        is_safe?(number_list) == :safe
      end)

    length(safe_lists)
  end
end
