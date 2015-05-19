#!/usr/bin/env ruby

require_relative '../lib/rb/tallyman'


generator = DeltaNotifier.new('./data/delta_lifts.xml')
puts 'Should be true : ' + generator.lifts_changed.to_s

generator = DeltaNotifier.new('./data/delta_no_change.xml')
puts 'Should be false : ' + generator.lifts_changed.to_s