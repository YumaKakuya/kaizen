# frozen_string_literal: true

require 'pstore'
require 'fileutils'
require 'date'
require 'time'

module Kaizen
  class Store
    DB_DIR = File.join(Dir.home, '.config', 'kaizen')
    DB_PATH = File.join(DB_DIR, 'improvements.db')

    MAX_TEXT = 200

    def initialize
      FileUtils.mkdir_p(DB_DIR)
      @pstore = PStore.new(DB_PATH)
    end

    def add(text)
      raise 'Improvement text is required.' if text.nil? || text.strip.empty?
      raise "Too long. Maximum #{MAX_TEXT} characters." if text.length > MAX_TEXT

      @pstore.transaction do
        entries = @pstore['entries'] || []
        new_id = (entries.map { |e| e[:id] }.max || 0) + 1
        entries << {
          id: new_id,
          text: text.strip,
          date: Date.today.to_s,
          time: Time.now.strftime('%H:%M')
        }
        @pstore['entries'] = entries
        new_id
      end
    end

    def undo
      @pstore.transaction do
        entries = @pstore['entries'] || []
        raise 'Nothing to undo.' if entries.empty?

        removed = entries.pop
        @pstore['entries'] = entries
        removed
      end
    end

    def today
      by_date(Date.today.to_s)
    end

    def yesterday
      by_date((Date.today - 1).to_s)
    end

    def week
      start_date = Date.today - 6
      range(start_date, Date.today)
    end

    def month
      start_date = Date.today - 29
      range(start_date, Date.today)
    end

    def log(days)
      start_date = Date.today - (days - 1)
      range(start_date, Date.today)
    end

    def streak
      dates = all_entries
              .map { |e| e[:date] }
              .uniq
              .sort
              .reverse

      return 0 if dates.empty?

      today_str = Date.today.to_s
      yesterday_str = (Date.today - 1).to_s
      return 0 unless [today_str, yesterday_str].include?(dates.first)

      count = 1
      (0...dates.length - 1).each do |i|
        break unless (Date.parse(dates[i]) - Date.parse(dates[i + 1])).to_i == 1

        count += 1
      end
      count
    end

    def total_count
      all_entries.length
    end

    def total_days
      all_entries.map { |e| e[:date] }.uniq.length
    end

    private

    def all_entries
      @pstore.transaction(true) do
        @pstore['entries'] || []
      end
    end

    def by_date(date_str)
      all_entries.select { |e| e[:date] == date_str }
    end

    def range(start_date, end_date)
      s = start_date.to_s
      e = end_date.to_s
      all_entries.select { |entry| entry[:date] >= s && entry[:date] <= e }
    end
  end
end
