Different Benshee tests of common functions
Comparisons:
1. String interpolation VS String concatenation (`"My #{example}"` VS `"My " <> example`)
2. Different map updates (`Map.put(map, :value, value)` VS `%{map | value: value}` VS `Map.update(map, :value, fn _ -> value end)`)
3. Add a day to a datetime, standard lib vs Timex (`DateTime.add(datetime, days * seconds_in_a_day` VS `Timex.shift(datetime, days: days)`)