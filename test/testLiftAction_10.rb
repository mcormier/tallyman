#!/usr/bin/env ruby

gem 'ppcurses', '=0.1.0'
require 'ppcurses'

require_relative '../lib/rb/tallyman'


screen = PPCurses::Screen.new

screen.run {
  music_action = LiftAction_10.new
  music_action.execute
}





