#!/usr/bin/env ruby

gem 'ppcurses', '=0.1.0'
require 'ppcurses'

require_relative '../lib/rb/tallyman'




@app = PPCurses::Application.new

music_action = LiftAction_10.new

@app.content_view = music_action.form

@app.launch