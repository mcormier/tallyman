#!/usr/bin/env ruby

gem 'ppcurses', '=0.1.2'
require 'ppcurses'

require_relative '../lib/rb/tallyman'


@app = PPCurses::Application.new

music_action = MusicAction.new

@app.content_view = music_action.form

@app.launch





