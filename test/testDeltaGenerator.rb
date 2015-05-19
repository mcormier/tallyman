#!/usr/bin/env ruby

require_relative '../lib/rb/tallyman'

@modified_table_set = Set.new
@modified_table_set.add('lifts')

# Test an empty set
generator = DeltaGenerator.new(Set.new)
generator.generate

generator = DeltaGenerator.new(@modified_table_set)
generator.generate
#generator.generate('delta.xml')