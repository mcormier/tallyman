#!/usr/bin/env ruby

require_relative '../lib/rb/tallyman'


@app = PPCurses::Application.new

music_action = MusicAction.new

@app.content_view = music_action.form

@app.launch





