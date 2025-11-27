# 🏆 The BPEagle Project: Ruby Code Golf Challenge

## Contest: Perlbatross 2025 Fukuoka

This repository chronicles my journey and progressive solutions to the Perlbatross 2025 Fukuoka Code Golf Contest. Our goal was to implement a simple **Byte Pair Encoding (BPE)**-like compression algorithm in the fewest bytes possible using Ruby.


**Final Result:** 109 Bytes (Tied for 9th place on the final leaderboard).

## 💡 The Challenge: Byte Pair Encoding (BPE)

The task requires iteratively finding the most frequent two-character pair (`XY`) in the input string and replacing all occurrences of that pair with the next available uppercase character (`A`, `B`, `C`, ...). The process stops when the most frequent pair appears only once (frequency $\le 1$).

**Input:** A string of space-separated words.
**Output:** Dictionary rules (`A:XY,B:YZ,...`) followed by the final compressed string.

## 🧠 The Algorithmic Core (The Struggle)

My main challenge was to implement the core BPE loop—**Find Max Frequency, Replace All, and Loop**—in the shortest possible Ruby structure while managing variables and output.

| Step | BPE Requirement | Ruby Implementation | Byte Cost Challenge |
| :--- | :--- | :--- | :--- |
| 1 | **Find Max Pair** | `s.scan(/(?=(\w\w))/).tally.max_by{_2}` | This is the fixed, complex core. |
| 2 | **Loop & Control** | Iterate through characters `A` to `Z` and break/filter when $v \le 1$. | Managing the loop structure was my main struggle. |
| 3 | **Build Rule** | `it + ?: + k` | Requires string concatenation. |
| 4 | **Output Formatting** | `puts rules, s` | Required complex string manipulation. |

-----

## 📉 Solution History: 115 Bytes $\to$ 109 Bytes

We explored three main structures to handle the loop and variable management.

### 1\. BPEagle01.rb: The `while` Loop (115 Bytes)

The initial approach used a classic `while` loop, which is robust but verbose due to variable initialization and the loop condition structure.

```ruby
s,c,a=gets,?@,[]
[s.gsub!(K,c.next!),a<<c+?:+K]while((K,),v=s.scan(/(?=(\w\w))/).tally.max_by{_2})&&v>1
puts a*?,,s
```

  * **Pros:** Clear flow. Uses the **Ruby idiom** `[statement, statement] while condition` to combine the replacement and rule-building inside the loop body.
  * **Cons:** Expensive initial setup (`s,c,a=gets,?@,[]` is 16 bytes). The loop variable (`c`) must be manually incremented (`c.next!`)—a necessary cost.

-----

### 2\. BPEagle02.rb: The `filter_map` Leap (110 Bytes)

To eliminate the expensive `while` loop setup and variable management, we pivoted to an **`Enumerable#filter_map`** structure, leveraging the `?A..?Z` range for iteration.

```ruby
s=gets
puts (?A..?Z).filter_map{(k,),v=s.scan(/(?=(\w\w))/).tally.max_by{_2}
(s.gsub!k,it;it+?:+k)if v>1}*?,,s
```

  * **Novelty:** Uses `(?A..?Z).filter_map` to both **loop** and **filter** the results.
      * The loop variable (`it`) automatically handles the `A`, `B`, `C`, ... generation.
      * The `if v>1` condition causes the block to return `nil` when compression stops, automatically filtered by `filter_map`.
  * **Byte Saving:** Saved 5 bytes by removing `c,a=...` and the `while` structure.

-----

### 3\. BPEagle03.rb: The Final 109-Byte Solution (The `map` Trick)

This was my final optimization, achieved by swapping the newly introduced `filter_map` (Ruby 2.7+) for the older, but equally short, **`map` + `-[p]`** idiom.

```ruby
s=gets
puts ((?A..?Z).map{(k,),v=s.scan(/(?=(\w\w))/).tally.max_by{_2}
(s.gsub!k,it;it+?:+k)if v>1}-[p])*?,,s
```

  * **Novelty:** Swapped `filter_map` for `map`. The resultant array contained rule strings and many `nil`s (from the `if v>1` condition failing).
  * **The Final Trick:** The `-[p]` (or `-[nil]`) idiom is the shortest way to remove `nil`s from an array in Ruby, saving 1 byte over `filter_map` (or 2 bytes over `compact`). This brought the final score to **109 bytes**.

-----

## 🚧 The Unsolved Gap: Why We Lost the Top Spot

My final 109-byte solution was robust but was 7 bytes longer than the winner's 102-byte solution. The key gap was the failure to anticipate **new-era Ruby code golf idioms** and the reuse of global variables.

| My Costly Assumptions | Winner's Solution (102B) | Byte Difference |
| :--- | :--- | :--- |
| **I/O Management** | Used `s=gets` and `puts ..., s`. | Used `#!ruby -p` to handle all I/O via `$_`. | **\~5 bytes** |
| **Array Accumulator** | Relied on `map` array creation (paid `-[p]` cost). | Used the global array **`$*` (ARGV)** as the rule accumulator. | **\~3 bytes** |
| **Control Flow** | Used `(expression) if condition`. | Used **Pattern Matching (`in`)** combined with **`or`** to simultaneously check the condition and execute the replacement. | **\~4 bytes** |

My approach maximized byte savings within the **function-oriented `map` structure**, while the winner achieved the absolute minimum by maximizing **side-effect-oriented global variable manipulation** and using the latest **Ruby 3.x Pattern Matching** features for control flow.

-----

### **Links**

  * **Contest Site:** [https://perlbatross.kayac.com/contest/2025fukuoka](https://perlbatross.kayac.com/contest/2025fukuoka)
