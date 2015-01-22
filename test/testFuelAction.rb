#!/usr/bin/env ruby

gem 'ppcurses', '=0.1.0'
require 'ppcurses'

require_relative '../lib/rb/tallyman'


@app = PPCurses::Application.new

fuel_action = FuelAction.new

@app.content_view = fuel_action.form

@app.launch




