data:extend({
  {
    type = "int-setting",
    name = "mithras-sandstorm-spawn-min-minutes",
    setting_type = "runtime-global",
    default_value = 15,
    minimum_value = 5,
    maximum_value = 120,
    order = "a-a"
  },
  {
    type = "int-setting",
    name = "mithras-sandstorm-spawn-max-minutes",
    setting_type = "runtime-global",
    default_value = 45,
    minimum_value = 5,
    maximum_value = 180,
    order = "a-b"
  },
  {
    type = "int-setting",
    name = "mithras-sandstorm-duration-min-seconds",
    setting_type = "runtime-global",
    default_value = 60,
    minimum_value = 30,
    maximum_value = 600,
    order = "a-c"
  },
  {
    type = "int-setting",
    name = "mithras-sandstorm-duration-max-seconds",
    setting_type = "runtime-global",
    default_value = 300,
    minimum_value = 30,
    maximum_value = 1200,
    order = "a-d"
  },
  {
    type = "double-setting",
    name = "mithras-sandstorm-speed-min",
    setting_type = "runtime-global",
    default_value = 0.1,
    minimum_value = 0.05,
    maximum_value = 1.0,
    order = "b-a"
  },
  {
    type = "double-setting",
    name = "mithras-sandstorm-speed-max",
    setting_type = "runtime-global",
    default_value = 0.3,
    minimum_value = 0.05,
    maximum_value = 1.0,
    order = "b-b"
  },
  {
    type = "int-setting",
    name = "mithras-sandstorm-size-min-tiles",
    setting_type = "runtime-global",
    default_value = 10,
    minimum_value = 5,
    maximum_value = 200,
    order = "b-c"
  },
  {
    type = "int-setting",
    name = "mithras-sandstorm-size-max-tiles",
    setting_type = "runtime-global",
    default_value = 100,
    minimum_value = 10,
    maximum_value = 300,
    order = "b-d"
  }
})
