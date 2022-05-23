defmodule MyBenchee do
  @doc """
  Name                           ips        average  deviation         median         99th %
  interpolation short       481.63 K        2.08 μs   ±694.11%           2 μs           4 μs
  interpolation medium      448.70 K        2.23 μs   ±218.61%           2 μs           4 μs
  interpolation long        436.03 K        2.29 μs    ±92.35%           2 μs           3 μs
  concatenation short       150.57 K        6.64 μs   ±210.39%           6 μs          17 μs
  concatenation medium      141.61 K        7.06 μs   ±234.05%           6 μs          21 μs
  concatenation long        124.14 K        8.06 μs   ±183.66%           7 μs          49 μs

  Comparison:
  interpolation short       481.63 K
  interpolation medium      448.70 K - 1.07x slower +0.152 μs
  interpolation long        436.03 K - 1.10x slower +0.22 μs
  concatenation short       150.57 K - 3.20x slower +4.56 μs
  concatenation medium      141.61 K - 3.40x slower +4.99 μs
  concatenation long        124.14 K - 3.88x slower +5.98 μs

  Interpolation WAY OVER concatenation
  """
  def interpolation_vs_concatenation() do
    short = for _ <- 1..10, into: "", do: "a"
    medium = for _ <- 1..100, into: "", do: "a"
    long = for _ <- 1..10_00, into: "", do: "a"

    Benchee.run(%{
      "interpolation short" => fn -> short <> short end,
      "concatenation short" => fn -> "#{short}#{short}" end,
      "interpolation medium" => fn -> medium <> medium end,
      "concatenation medium" => fn -> "#{medium}#{medium}" end,
      "interpolation long" => fn -> long <> long end,
      "concatenation long" => fn -> "#{long}#{long}" end
    })
  end

  @doc """
  Name                        ips        average  deviation         median         99th %
  map_put                217.91 M        4.59 ns  ±7240.34%           0 ns           0 ns
  map_merge              209.59 M        4.77 ns  ±7305.55%           0 ns           0 ns
  map_3_elem_put         209.21 M        4.78 ns  ±7389.60%           0 ns           0 ns
  map_3_elem_merge       198.80 M        5.03 ns  ±7185.40%           0 ns           0 ns
  map_update              14.48 M       69.06 ns ±46467.13%           0 ns           0 ns
  map_3_elem_update       12.35 M       81.00 ns ±32113.02%           0 ns           0 ns

  Comparison:
  map_put                217.91 M
  map_merge              209.59 M - 1.04x slower +0.182 ns
  map_3_elem_put         209.21 M - 1.04x slower +0.191 ns
  map_3_elem_merge       198.80 M - 1.10x slower +0.44 ns
  map_update              14.48 M - 15.05x slower +64.47 ns
  map_3_elem_update       12.35 M - 17.65x slower +76.41 ns
  """
  def map_merging_vs_map_put() do
    map = %{a: :a}
    map_put = fn -> map |> Map.put(:a, :a) end
    map_merge = fn -> %{map | a: :a} end
    map_update = fn -> Map.update!(map, :a, fn _ -> :a end) end

    map_3_elem = %{a: :a, b: :b, c: :c}
    map_3_elem_put = fn -> map_3_elem |> Map.put(:a, :a) |> Map.put(:c, :c) |> Map.put(:b, :b) end
    map_3_elem_merge = fn -> %{map_3_elem | a: :a, c: :c, b: :b} end

    map_3_elem_update = fn ->
      Map.update!(map_3_elem, :a, fn _ -> :a end)
      |> Map.update!(:b, fn _ -> :b end)
      |> Map.update!(:c, fn _ -> :c end)
    end

    Benchee.run(%{
      "map_put" => map_put,
      "map_merge" => map_merge,
      "map_update" => map_update,
      "map_3_elem_put" => map_3_elem_put,
      "map_3_elem_merge" => map_3_elem_merge,
      "map_3_elem_update" => map_3_elem_update
    })
  end

  @doc """
  ##### With input one date shift one day #####
  Name                ips        average  deviation         median         99th %
  timex_add      596.17 K        1.68 μs  ±1470.45%        0.90 μs        2.90 μs
  date_add        56.28 K       17.77 μs    ±96.78%       13.90 μs       71.49 μs

  Comparison:
  timex_add      596.17 K
  date_add        56.28 K - 10.59x slower +16.09 μs

  ##### With input one date shift 500 days #####
  Name                ips        average  deviation         median         99th %
  timex_add      164.33 K        6.09 μs   ±358.61%        4.90 μs       21.90 μs
  date_add        58.35 K       17.14 μs   ±172.69%       13.90 μs       71.90 μs

  Comparison:
  timex_add      164.33 K
  date_add        58.35 K - 2.82x slower +11.05 μs

  ##### With input 20 dates shift one day #####
  Name                ips        average  deviation         median         99th %
  timex_add       27.10 K       36.90 μs    ±94.07%       28.90 μs      127.90 μs
  date_add         4.03 K      248.40 μs    ±34.78%      207.90 μs      559.90 μs

  Comparison:
  timex_add       27.10 K
  date_add         4.03 K - 6.73x slower +211.51 μs

  ##### With input 20 dates shift 500 days #####
  Name                ips        average  deviation         median         99th %
  timex_add        6.89 K      145.11 μs    ±36.16%      123.90 μs      310.62 μs
  date_add         4.42 K      226.25 μs    ±30.66%      190.90 μs      463.90 μs

  Comparison:
  timex_add        6.89 K
  date_add         4.42 K - 1.56x slower +81.14 μs

  ##### With input 400 dates shift one day #####
  Name                ips        average  deviation         median         99th %
  timex_add        1.62 K        0.62 ms    ±27.63%        0.56 ms        1.27 ms
  date_add        0.140 K        7.15 ms    ±42.82%        6.66 ms       19.09 ms

  Comparison:
  timex_add        1.62 K
  date_add        0.140 K - 11.61x slower +6.53 ms

  ##### With input 400 dates shift 500 days #####
  Name                ips        average  deviation         median         99th %
  timex_add        379.99        2.63 ms    ±26.93%        2.44 ms        4.79 ms
  date_add         148.53        6.73 ms    ±27.12%        6.52 ms       11.78 ms

  Comparison:
  timex_add        379.99
  date_add         148.53 - 2.56x slower +4.10 ms
  """
  def date_add_vs_timex_add() do
    one_day = 3600 * 24

    Benchee.run(
      %{
        "date_add" => fn {inputs, days_to_shift} ->
          Enum.map(inputs, fn input -> DateTime.add(input, days_to_shift * one_day) end)
        end,
        "timex_add" => fn {inputs, days_to_shift} ->
          Enum.map(inputs, fn input -> Timex.shift(input, days: days_to_shift) end)
        end
      },
      inputs: %{
        "one date shift one day" => {[Timex.now()], 1},
        "one date shift 500 days" => {[Timex.now()], 500},
        "20 dates shift one day" => {1..20 |> Enum.map(fn _ -> Timex.now() end), 1},
        "20 dates shift 500 days" => {1..20 |> Enum.map(fn _ -> Timex.now() end), 500},
        "400 dates shift one day" => {1..400 |> Enum.map(fn _ -> Timex.now() end), 1},
        "400 dates shift 500 days" => {1..400 |> Enum.map(fn _ -> Timex.now() end), 500}
      }
    )
  end

  @doc """
  Name             ips        average  deviation         median         99th %
  SHA256      299.47 K        3.34 μs   ±708.74%           3 μs           7 μs
  SHA224      297.41 K        3.36 μs   ±795.19%           3 μs           7 μs
  MD5         269.11 K        3.72 μs   ±789.67%           3 μs           7 μs

  Comparison:
  SHA256      299.47 K
  SHA224      297.41 K - 1.01x slower +0.0231 μs
  MD5         269.11 K - 1.11x slower +0.38 μs
  """
  def md5_vs_sha2() do
    to_hash = %{
      "payload" => %{
        "before" => nil,
        "after" => %{
          "categoryskills_idCategoryskills" => 1,
          "danger" => nil,
          "disabled" => 0,
          "equipments" => nil,
          "idSkills" => 4,
          "name" => "CP",
          "unique_reference" => "4"
        },
        "source" => %{
          "db" => "toto",
          "table" => "toto"
        }
      }
    }

    hashit = fn algo ->
      str = Jason.encode!(to_hash)
      :crypto.hash(algo, str)
    end

    Benchee.run(%{
      "MD5" => fn -> hashit.(:md5) end,
      "SHA224" => fn -> hashit.(:sha224) end,
      "SHA256" => fn -> hashit.(:sha256) end
    })
  end
end
