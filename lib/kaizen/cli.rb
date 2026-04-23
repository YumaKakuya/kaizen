# frozen_string_literal: true

require 'date'
require_relative 'version'
require_relative 'store'

module Kaizen
  class CLI
    BANNER = "Small improvements, every day.\nThe compound interest of discipline."

    def self.start(argv)
      new.run(argv)
    end

    def run(argv)
      command = argv.shift

      if command.nil? || %w[-h --help].include?(command)
        puts help
        exit 0
      end

      case command
      when '-v', '--version'
        puts "kaizen #{Kaizen::VERSION}"
        exit 0
      when 'done'
        handle_done(argv)
      when 'undo'
        handle_undo
      when 'today'
        handle_today
      when 'yesterday'
        handle_yesterday
      when 'week'
        handle_week
      when 'month'
        handle_month
      when 'log'
        handle_log(argv)
      when 'streak'
        handle_streak
      when 'stats'
        handle_stats
      else
        warn "Unknown command: '#{command}'"
        puts help
        exit 1
      end
    rescue StandardError => e
      warn "Error: #{e.message}"
      exit 1
    end

    private

    def help
      <<~HELP
        #{BANNER}

        Usage: kaizen <command> [args]

        Record:
          done <text>        Record an improvement
          undo               Remove the last recorded entry

        Review:
          today              Show today's improvements
          yesterday          Show yesterday's improvements
          week               Show last 7 days
          month              Show last 30 days
          log [days]         Show last N days (default: 7)

        Progress:
          streak             Show consecutive-day streak
          stats              Show all-time statistics

        Options:
          -v, --version      Show version
          -h, --help         Show this help message

        Examples:
          kaizen done "Removed 3 unused imports"
          kaizen done "Split long function into two"
          kaizen done "Added error handling to API call"
          kaizen today
          kaizen week
          kaizen streak
      HELP
    end

    def handle_done(argv)
      text = argv.join(' ').strip

      if text.empty?
        warn 'Error: Describe what you improved.'
        puts 'Usage: kaizen done "your improvement"'
        exit 1
      end

      id = store.add(text)
      today_count = store.today.length
      streak = store.streak

      puts "Recorded ##{id}: #{text}"

      if today_count == 1
        puts 'First improvement today.'
      else
        puts "#{today_count} improvements today."
      end

      puts "Streak: #{streak} day#{streak > 1 ? 's' : ''}" if streak >= 2
    end

    def handle_undo
      removed = store.undo
      puts "Removed: #{removed[:text]}"
    end

    def handle_today
      entries = store.today
      if entries.empty?
        puts 'Nothing recorded today. Make one small improvement.'
        return
      end

      puts "Today (#{entries.length}):"
      render_entries(entries)
    end

    def handle_yesterday
      entries = store.yesterday
      if entries.empty?
        puts 'Nothing recorded yesterday.'
        return
      end

      puts "Yesterday (#{entries.length}):"
      render_entries(entries)
    end

    def handle_week
      render_range('Last 7 days', store.week)
    end

    def handle_month
      render_range('Last 30 days', store.month)
    end

    def handle_log(argv)
      days = (argv.shift || 7).to_i
      if days <= 0
        warn 'Error: Days must be a positive number.'
        exit 1
      end
      render_range("Last #{days} days", store.log(days))
    end

    def handle_streak
      s = store.streak
      if s.zero?
        puts 'No streak. Record an improvement today to start one.'
      else
        puts "Current streak: #{s} day#{s > 1 ? 's' : ''}"
      end
    end

    def handle_stats
      total = store.total_count
      days = store.total_days
      streak = store.streak
      today = store.today.length

      if total.zero?
        puts 'No improvements recorded yet.'
        puts 'Start with: kaizen done "your first improvement"'
        return
      end

      avg = days > 0 ? (total.to_f / days).round(1) : 0

      puts 'All time:'
      puts "  Total improvements: #{total}"
      puts "  Active days:        #{days}"
      puts "  Average per day:    #{avg}"
      puts "  Current streak:     #{streak} day#{streak != 1 ? 's' : ''}"
      puts "  Today:              #{today}"
    end

    def render_entries(entries)
      entries.each do |e|
        puts "  [#{e[:time]}] #{e[:text]}"
      end
    end

    def render_range(label, entries)
      if entries.empty?
        puts "#{label}: nothing recorded."
        return
      end

      grouped = entries.group_by { |e| e[:date] }
      total = entries.length

      puts "#{label}: #{total} improvement#{total > 1 ? 's' : ''}"
      puts '-' * 36

      grouped.sort.reverse.each do |date, day_entries|
        weekday = Date.parse(date).strftime('%a')
        puts "  #{date} (#{weekday}) — #{day_entries.length}"
        day_entries.each do |e|
          puts "    [#{e[:time]}] #{e[:text]}"
        end
      end
    end

    def store
      @store ||= Store.new
    end
  end
end
