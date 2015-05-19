#!/usr/bin/env ruby

gem 'ppcurses', '=0.1.0'
require 'ppcurses'

require_relative '../lib/rb/tallyman'


@app = PPCurses::Application.new

lift_action = LiftAction.new

@app.content_view = lift_action.form

@app.launch