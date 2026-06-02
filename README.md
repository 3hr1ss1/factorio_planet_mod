# Mithra - a Factorio Planet Mod

A factorio mod for our Software Engineering Subject.

## Concept

Mithra is a desert-like planet on the fourth ring of the Factorio solar system. There is barely anything more than sand, sun and vicious creatures. But those who can make sand and sun their own will unlock new resources and buildings to scale the factory. This is the way!

## Contents

### Flora and Fauna

- New planet (desert)
- Mobs and spawners
- New plants (cacti)
- A moving storm, damaging buildings and players over time

### Ressource Gaining

- Gaining **energy** by using solar
- Gaining **wood** by harvesting cacti
- Gaining **coarse sand** by mining anywhere with **core drill**
- Gaining **silicon ore** by mining on **silicon deposit**
- Gaining **oil** by pumping on **crude oil deposit**
- Gaining **water** by pumping anywhere with **core pumpjack**

### Products

- Gaining **{5-7} stone, {1-3} silicia sand** by centrifuge **{10} coarse sand** 
- Gaining **{7-8} stone, {1} copper ore, {1-2} iron ore, {1} coal** by centrifuge **{10} stone**
- Gaining **{1} glass** by smelting **{1} silicia sand**
- Gaining **{1} silicon ingot** by smelting **{1} silicon dust**

### Items

- Nuclear Artillery Shell
  - Description: A atomic bomb, shootable by artillery
  - Recipe: {1} artillery-shell, {30} silicon ingot, {1} atomic-bomb

- Laser-Science Pack
  - Description: New Science Pack for unlocking Mithras Technology
  - Recipe: {5} glass, {2} silicon Ingot

### Buildings

- Solar panel MK2
  - Description: A better Solar panel
  - Parameter: Peak Output 300 kW
  - Recipe: {5} solar panel, {5} efficiency module 1, {25} glass, {5} silicon ingot
    
- Short handed Inserter
  - Description: Puts Items on the front row of the belt, instead of the back one
  - Parameter: 432°/s Rotation Speed
  - Recipe: {1} inserter, {2} electric circuits, {2} iron plates
    
- Solar oven
  - Description: A better furnance for smelting ores, stone and glass using the energy of the sun. The oven doesn´t work during night.
  - Paramter: Base Crafting Speed 4; Base Productivity 50%; 4 Module Slots
  - Recipe: {2} electric furnace, {2} speed module 1, {10} glass, {5} silicon ingot
    
- Core pumpjack
  - Description: Will extract the Ground Fluid of a planet
  - Parameter: 120/s Ratio (1/10 of the offshore pump)
  - Production: 
    - Nauvis: Water
    - Vulcanos: Lava
    - Fulgora: Heavy Oil
    - Gleba: Water
    - Aquillo: Ammoniacal solution
    - Mithras: Water
  - Recipe: {1} pumpjack, {10} advanced circuits, {10} engines, {30} silicon ingot, {50} steel
    
- Ion-Dome
  - Description: Slows down surrounding storms to prevent players and the factory from damage
  - Parameter:
  - Recipe: {10} processing unit, {20} silicon ingot, {15} glass, {5} concrete, {50} steel plate
    
- Solar Precission Plant
  - Description: A better assembly machine for science crafting. Allows crafting of all 12 science packs of base game and space age. Only Machine to craft the Laser-Science pack
  - Parameter: Max Base Crafting Speed 4; Base Productivity 50%
  - Recipe: {50} advanced circuits, {20} refined concrete, {50} glass, {15} silicon ingot
  
- Dedicated Storage Chest
  - Description: A different storage chest for bot bases, that allows to only store 1 item but in infinite quantity. 
  - Paramter: Max Unique Item 1; Capacity nearly infinite
  - Recipe: {10} steel chest, {20} advanced circuits
    
- Core Miner
  - Description: A miner, that can be placed anywhere. Extracts planet based ressources out of the planet core.
  - Production:
    - Basic Recipe:
      - Mithras: {5} coarse sand
      - Else: {5} stone
    - Advanced Recipe: 
      - Nauvis: {5} stone, {2} iron ore, {1} copper ore and {1} coal
      - Vulcanos: {5} stone, {3} calcite, {1} tungsten ore
      - Fulgora: {5} stone, {3} scrap
      - Gleba: {5} stone, {2} sulfur
      - Aquillo: {5} stone, {2} lithium
      - Mithras: {8} coarse sand, {1} silicon ore, {1} iron ore, {1} copper ore
  - Recipe: {20} steel-plate, {2} electric-mining-drill, {10} advanced-circuit, {8} engine-unit

### New Technology

- Planet Discovery Mithras
  - Unlocks: Travel to Mithras, Core Miner, Core Miner Basic Recipes, Core Pumpjack
  - Requires: Space Platform Thruster Technolgy, Solar Energy Technology, Centrifuge Technology
  - Costs: {1000} red, green, blue, white, 60s

- Intercontinental Bombing
  - Unlocks: Nuclear Artillery Shell
  - Requires: Planet Discovery Mithras, Atomic Bomb, Artillery, Laser Science Pack
  - Costs: {1500} red, green, black, blue, yellow, white, laser-science, 30s

- Short-Handed Inserter
  - Unlocks: Short-Handed Inserter
  - Requires: Planet Discovery Mithras, Automation Technology, Laser Science Pack
  - Costs: {1000} red, green, blue, purple, yellow, white, laser-science, 60s

- Solar Energy MK2
  - Unlocks: Solar Panel MK2
  - Requires: Solar Energy, Laser Science Pack
  - Costs: {1000} red, green, blue, purple, yellow, white, laser-science, 60s

- Advanced Core Mining
  - Unlocks: Core Miner Advanced Recipes
  - Requires: Planet Discovery Mithras
  - Costs: {100} red, green, blue, purple, yellow, white, laser-science, 30s

- Silicon Processing
  - Unlocks: Silicon Ingot Smelting
  - Requires: Mine 10 Silicon ore

- Sand Processing
  - Unlocks: Silicia Sand Centrifuge Recipe, Stone Centrifuge Recipe, Glass Smelting
  - Requires: Mine 10 Coarse Sand

- Solar Oven
  - Unlocks: Solar Oven
  - Requires: Silicon Processing, Sand Processing, Advanced Material Processing, Solar Science Pack
  - Costs: {100} red, green, blue, purple, yellow, white, laser-science, 30s

- Solar Precission Plant
  - Unlocks: Solar Precission Plant
  - Requires: Smelt 10 Silicon Ingot, Smelt 10 Glass

- Laser Science Pack
  - Unlocks: Laser Science Pack
  - Requires: Craft Solar Precission Plant

### Mobs
