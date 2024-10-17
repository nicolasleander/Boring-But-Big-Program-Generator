# Boring But Big 4-Week Training Program Generator

This Ruby script generates a 4-week "Boring But Big" (BBB) strength training program based on the popular 5/3/1 method. The program includes four main lifts (Overhead Press, Deadlift, Bench Press, and Squat), with 5/3/1 progression and supplementary 5x10 sets for accessory work. It also generates a `.ics` file to schedule the training days in a calendar.

## Features

- Hardcoded 1RM (one-rep max) values for each of the four main lifts.
- Calculates the training max (90% of 1RM) for each lift.
- 5/3/1 progression over three weeks, with a deload in the fourth week.
- Supplementary 5x10 sets for hypertrophy (Boring But Big - BBB).
- Lat and abs accessory work for balance.
- Generates a `.ics` calendar file with events for each workout day.
  
## Getting Started

### Prerequisites

You need to have Ruby installed on your system. You can check your Ruby version by running:

```bash
ruby -v
```

If Ruby is not installed, follow the instructions [here](https://www.ruby-lang.org/en/documentation/installation/) to install it.

### Usage

1. Clone this repository:

    ```bash
    git clone https://github.com/yourusername/boring-but-big-generator.git
    cd boring-but-big-generator
    ```

2. Run the script:

    ```bash
    ruby bbb_generator.rb
    ```

    This will print the full 4-week training program to the console and generate an `.ics` file for calendar scheduling.

3. Import the `boring_but_big_program.ics` file into your preferred calendar app to schedule your training days.

### Customization

- You can modify the hardcoded 1RM values for each lift by adjusting the following variables in the script:

  ```ruby
  ohp_1rm = 75
  deadlift_1rm = 170
  bench_1rm = 105
  squat_1rm = 140
  ```

- The script also calculates a 90% training max based on these values. You can change this multiplier as well if desired.

### Output

- The program prints a detailed week-by-week workout plan for each lift, along with accessory work.
- The `.ics` file includes training sessions for each lift, which you can add to your calendar.

## License

This project is licensed under the MIT License.
