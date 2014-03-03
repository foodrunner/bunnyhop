module BunnyHop
  module Logger
    def self.log(message, e = nil)
      puts "#{message}\n"
      puts "\t#{e.to_s}\n\tstack: #{e.backtrace.join("\n\t")}" unless e.nil?
      return 0
    end
  end
end
