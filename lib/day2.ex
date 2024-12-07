defmodule Day2 do
  @moduledoc false

  def read_input(input_path) do
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

  @spec detect_sorting(nonempty_maybe_improper_list()) :: :decrease | :equal | :increase
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

  def valid_increase?(first, second) do
    second >= first + 1 and second <= first + 3
  end

  def valid_decrease?(first, second) do
    second <= first - 1 and second >= first - 3
  end

  def detect_state_with_one_outlier(_numbers, 2, _sorting) do
    :unsafe
  end

  def detect_state_with_one_outlier([_first], _outlier_count, _sorting) do
    :safe
  end

  def detect_state_with_one_outlier([_head | tail], outlier_count, :equal) do
    sorting = detect_sorting(tail)
    detect_state_with_one_outlier(tail, outlier_count + 1, sorting)
  end

  def detect_state_with_one_outlier([first, second | rest], outlier_count, :increase) do
    cond do
      valid_increase?(first, second) ->
        detect_state_with_one_outlier([second | rest], outlier_count, :increase)

      outlier_count == 0 ->
        detect_state_with_one_outlier([first | rest], 1, :increase)

      outlier_count == 1 ->
        :unsafe
    end
  end

  def detect_state_with_one_outlier([first, second | rest], outlier_count, :decrease) do
    cond do
      valid_decrease?(first, second) ->
        detect_state_with_one_outlier([second | rest], outlier_count, :decrease)

      outlier_count == 0 ->
        detect_state_with_one_outlier([first | rest], 1, :decrease)

      outlier_count == 1 ->
        :unsafe
    end
  end

  def detect_state_with_one_outlier([_first], outlier_count, _sorting) do
    cond do
      outlier_count <= 1 -> :safe
      outlier_count > 1 -> :unsafe
    end
  end

  def is_safe_with_outlier?(numbers) do
    sorting = detect_sorting(numbers)
    detect_state_with_one_outlier(numbers, 0, sorting)
  end

  def count_safe_with_outlier_lists(number_lists) do
    safe_lists =
      Enum.filter(number_lists, fn number_list ->
        is_safe_with_outlier?(number_list) == :safe
      end)

    length(safe_lists)
  end

  def is_safe_increase_level?(numbers) do
    is_safe_increase_level?(numbers, :ok)
  end

  def is_safe_increase_level?(numbers, state) do
    if length(numbers) == 1 do
      :safe
    else
      [first, second | tail] = numbers

      cond do
        valid_increase?(first, second) -> is_safe_increase_level?([second | tail], state)
        state == :outliner -> :unsafe
        true -> is_safe_increase_level?([first | tail], :outliner)
      end
    end
  end

  def is_safe_decrease_level?(numbers) do
    is_safe_decrease_level?(numbers, :ok)
  end

  def is_safe_decrease_level?(numbers, state) do
    if length(numbers) == 1 do
      :safe
    else
      [first, second | tail] = numbers

      cond do
        valid_decrease?(first, second) -> is_safe_decrease_level?([second | tail], state)
        state == :outliner -> :unsafe
        true -> is_safe_decrease_level?([first | tail], :outliner)
      end
    end
  end

  def forward_to_sorting_checker(numbers) do
    forward_to_sorting_checker(numbers, :ok)
  end

  def forward_to_sorting_checker(numbers, state) do
    if length(numbers) == 1 do
      :safe
    else
      [first, second | _tail] = numbers

      cond do
        first == second and state == :ok ->
          forward_to_sorting_checker(tl(numbers), :outlier)

        first == second and state == :outlier ->
          :unsafe

        first < second ->
          is_safe_increase_level?(numbers, state)

        first > second ->
          is_safe_decrease_level?(numbers, state)
      end
    end
  end

  def count_safes(lines) do
    states = Enum.map(lines, fn line -> forward_to_sorting_checker(line) end)
    safe_states = Enum.filter(states, fn state -> state == :safe end)
    length(safe_states)
  end
end
