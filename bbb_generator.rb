require 'date'
require 'securerandom'

# Hardcoded 1RM values (you can adjust these as needed)
ohp_1rm = 75
deadlift_1rm = 170
bench_1rm = 105
squat_1rm = 140

# Calculate Training Max (90% of 1RM)
ohp_tm = (ohp_1rm * 0.9).round
deadlift_tm = (deadlift_1rm * 0.9).round
bench_tm = (bench_1rm * 0.9).round
squat_tm = (squat_1rm * 0.9).round

# Calculate start date (next Monday)
start_date = Date.today + ((1 - Date.today.wday) % 7)

# Program description
program_description = "4-week Boring But Big (BBB) program. Main lifts follow 5/3/1 progression, followed by 5x10 BBB sets with ascending weights."

# 5/3/1 percentages and rep schemes for each week
five_three_one = {
  1 => { percentages: [0.65, 0.75, 0.85], reps: [5, 5, "5+"] },
  2 => { percentages: [0.70, 0.80, 0.90], reps: [3, 3, "3+"] },
  3 => { percentages: [0.75, 0.85, 0.95], reps: [5, 3, "1+"] },
  4 => { percentages: [0.40, 0.50, 0.60], reps: [5, 5, 5] }  # Deload week
}

# BBB percentages (ascending)
bbb_percentages = [0.30, 0.40, 0.50, 0.60, 0.70]

# Training schedule
training_schedule = [
  ["Monday - OHP", ->(week, tm) { 
    main = five_three_one[week][:percentages].map { |p| (tm * p).round }
    reps = five_three_one[week][:reps]
    bbb = bbb_percentages.map { |p| (tm * p).round }
    {
      "OHP (5/3/1)": "#{main[0]}x#{reps[0]}, #{main[1]}x#{reps[1]}, #{main[2]}x#{reps[2]}",
      "OHP (BBB)": "5x10 @ #{bbb.join(', ')} kg",
      "Lat work": "5x10"
    }
  }],
  ["Tuesday - Deadlift", ->(week, tm) { 
    main = five_three_one[week][:percentages].map { |p| (tm * p).round }
    reps = five_three_one[week][:reps]
    bbb = bbb_percentages.map { |p| (tm * p).round }
    {
      "Deadlift (5/3/1)": "#{main[0]}x#{reps[0]}, #{main[1]}x#{reps[1]}, #{main[2]}x#{reps[2]}",
      "Deadlift (BBB)": "5x10 @ #{bbb.join(', ')} kg",
      "Abs": "5 sets"
    }
  }],
  ["Thursday - Bench Press", ->(week, tm) { 
    main = five_three_one[week][:percentages].map { |p| (tm * p).round }
    reps = five_three_one[week][:reps]
    bbb = bbb_percentages.map { |p| (tm * p).round }
    {
      "Bench Press (5/3/1)": "#{main[0]}x#{reps[0]}, #{main[1]}x#{reps[1]}, #{main[2]}x#{reps[2]}",
      "Bench Press (BBB)": "5x10 @ #{bbb.join(', ')} kg",
      "Lat work": "5x10"
    }
  }],
  ["Friday - Squat", ->(week, tm) { 
    main = five_three_one[week][:percentages].map { |p| (tm * p).round }
    reps = five_three_one[week][:reps]
    bbb = bbb_percentages.map { |p| (tm * p).round }
    {
      "Squat (5/3/1)": "#{main[0]}x#{reps[0]}, #{main[1]}x#{reps[1]}, #{main[2]}x#{reps[2]}",
      "Squat (BBB)": "5x10 @ #{bbb.join(', ')} kg",
      "Abs": "5 sets"
    }
  }]
]

# Display program in console
puts "\nBoring But Big (BBB) 4-Week Program:"
puts "===================================="
puts "Training Maxes: OHP #{ohp_tm}kg, Deadlift #{deadlift_tm}kg, Bench Press #{bench_tm}kg, Squat #{squat_tm}kg"
puts

4.times do |week|
  puts "Week #{week + 1}#{week == 3 ? ' (Deload)' : ''}"
  puts "--------"
  training_schedule.each do |day, workout|
    puts day
    case day
    when /OHP/
      workout.call(week + 1, ohp_tm).each { |exercise, scheme| puts "  #{exercise}: #{scheme}" }
    when /Deadlift/
      workout.call(week + 1, deadlift_tm).each { |exercise, scheme| puts "  #{exercise}: #{scheme}" }
    when /Bench/
      workout.call(week + 1, bench_tm).each { |exercise, scheme| puts "  #{exercise}: #{scheme}" }
    when /Squat/
      workout.call(week + 1, squat_tm).each { |exercise, scheme| puts "  #{exercise}: #{scheme}" }
    end
    puts
  end
  puts
end

# Generate ICS content
ics_content = ["BEGIN:VCALENDAR", "VERSION:2.0", "PRODID:-//hacksw/handcal//NONSGML v1.0//EN"]

4.times do |week|
  training_schedule.each_with_index do |(day, workout), index|
    event_date = start_date + week * 7 + [0, 1, 3, 4][index]  # Monday, Tuesday, Thursday, Friday
    event_start = event_date.strftime("%Y%m%dT180000Z")
    event_end = event_date.strftime("%Y%m%dT190000Z")

    ics_content << "BEGIN:VEVENT"
    ics_content << "UID:#{SecureRandom.uuid}"
    ics_content << "DTSTAMP:#{Time.now.strftime("%Y%m%dT%H%M%SZ")}"
    ics_content << "DTSTART:#{event_start}"
    ics_content << "DTEND:#{event_end}"
    ics_content << "SUMMARY:BBB - #{day}"
    case day
    when /OHP/
      description = workout.call(week + 1, ohp_tm).map { |exercise, scheme| "#{exercise}: #{scheme}" }.join("\\n")
    when /Deadlift/
      description = workout.call(week + 1, deadlift_tm).map { |exercise, scheme| "#{exercise}: #{scheme}" }.join("\\n")
    when /Bench/
      description = workout.call(week + 1, bench_tm).map { |exercise, scheme| "#{exercise}: #{scheme}" }.join("\\n")
    when /Squat/
      description = workout.call(week + 1, squat_tm).map { |exercise, scheme| "#{exercise}: #{scheme}" }.join("\\n")
    end
    ics_content << "DESCRIPTION:#{description}"
    ics_content << "END:VEVENT"
  end
end

ics_content << "END:VCALENDAR"

# Write to file
File.write("boring_but_big_program.ics", ics_content.join("\n"))

puts "ICS file 'boring_but_big_program.ics' has been generated successfully."
puts "The program starts on #{start_date.strftime('%A, %B %d, %Y')} and runs for 4 weeks."
