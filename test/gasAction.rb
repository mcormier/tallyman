#!/usr/bin/env ruby

require_relative '../lib/rb/tallyman'


@app = PPCurses::Application.new

fuel_action = GasAction.new

@app.content_view = fuel_action.form

@app.launch




