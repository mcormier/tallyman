#!/usr/bin/env ruby

require_relative '../lib/rb/tallyman'

config_loader = Tallyman::ConfigLoader.new
config = config_loader.load

lifting_domain = LiftingDomain.new

lift_action = lifting_domain.create_action(nil, config)

@app = PPCurses::Application.new
@app.content_view = lift_action.form
@app.launch