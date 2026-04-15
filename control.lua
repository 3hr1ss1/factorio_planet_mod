local sandstorm = require("scripts.sandstorm")

script.on_init(function()
  sandstorm.on_init()
end)

script.on_configuration_changed(function()
  sandstorm.on_configuration_changed()
end)

script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
  sandstorm.on_runtime_mod_setting_changed(event)
end)

script.on_nth_tick(sandstorm.get_update_interval(), function()
  sandstorm.on_update()
end)
