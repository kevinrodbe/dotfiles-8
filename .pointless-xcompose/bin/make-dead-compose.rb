#!/usr/bin/env ruby1.9.1
require 'pp'
require File.dirname(__FILE__) + '/keysymdef.rb'
require File.dirname(__FILE__) + '/xcompose_parser.rb'

exit if ARGV.size == 0
files = ARGV.collect do |fname|
  if not File.readable?(fname)
    $stderr.puts("Error: Cannot read file #{fname}.")
    exit 1
  end
end

Map = {
  '<apostrophe>' => '<dead_acute>',
  '<quotedbl>' => '<dead_diaeresis>',
  '<asciicircum>' => '<dead_circumflex>',
  '<asciitilde>' => '<dead_tilde>'
}

def has_undead(str)
  Map.keys.each do |undead|
    return true if str.match(undead)
  end
  false
end

def deadize(str)
  out = str
  Map.keys.each do |undead|
    out.gsub!(undead, Map[undead])
  end
  out
end

puts <<EOF
# Autogenerated by #{File.basename $0} at #{Time.utc(*Time.now.to_a).strftime('%Y-%m-%d %H:%M:%S %Z')}
EOF

buffer=[]
ARGV.each do |fname|
  puts "\n# Starting #{fname}."
  File.open(fname, 'r') do |f|
    f.each_line do |l|
      next if l.match(/^#/)
      if has_undead(l)
        dead = deadize(l)
        if not buffer.member? dead
          puts dead
          buffer << dead
        end
      end
    end
  end
end
