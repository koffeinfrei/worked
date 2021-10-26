require "cli"

require "./store"
require "./date_parser"
require "./entry_type"
require "./day_summary"

HELP_FOOTER = "Made with ☕️  by Koffeinfrei"

class AtWork < Cli::Supercommand
  class Start < Cli::Command
    class Options
      arg "start",
        required: true,
        desc: "The time you start working. Can be 'now' or a specific time like '08:15'"
    end

    def run
      store = Store.new
      store.create_database
      store.insert(EntryType::Start, DateParser.parse(args.start))
    end
  end

  class Stop < Cli::Command
    class Options
      arg "stop",
        required: true,
        desc: "The time you stop working. Can be 'now' or a specific time like '17:30'"
    end

    def run
      store = Store.new
      store.create_database
      store.insert(EntryType::Stop, DateParser.parse(args.stop))
    end
  end

  class Show < Cli::Command
    def run
      raw_entries = Store.new.select(Time.local)
      puts DaySummary.new(raw_entries).to_s
    end
  end
end

AtWork.run(ARGV)
