#!/usr/bin/env ruby

require_relative '../lib/rb/tallyman'


@app = PPCurses::Application.new

lift_action = LiftAction.new

@app.content_view = lift_action.form

@app.launch