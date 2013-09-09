#!/usr/bin/env ruby

require 'set'
require_relative '../lib/rb/tallyman'

@modified_table_set = Set.new()
@modified_table_set.add('lifts')

generator = DeltaGenerator.new(@modified_table_set)
generator.generate
generator.generate('delta.xml')