# shadowui - premium roblox ui library

a high-performance, panel-based roblox ui library with a premium minecraft-style aesthetic. designed for the modern roblox community with real-time blur, rainbow accents, and a permanent watermark.

---

## core features
- **dynamic watermark:** a permanent watermark showing `shadowui | player_name | fps` with a stylish pink-to-purple gradient text.
- **independent panels:** multiple draggable windows for better organization.
- **premium aesthetic:** all-lowercase typography, clean fonts, and professional dark themes.
- **acrylic blur:** real-time background blur that updates dynamically.
- **full customization:**
  - **rainbow accent:** shifting colors for all interactive elements.
  - **blur control:** adjustable blur intensity via slider.
  - **transparency:** live control over window transparency.
  - **text casing:** toggle between lowercase and normal text.
- **clean code:** optimized code with zero comments for maximum performance and portability.

---

## tutorial: how to use shadowui

### 1. for executors (xeno, synapse, krnl, etc.)
the easiest way is to use the standalone version.
1. copy the entire content of `example.lua`.
2. paste it into your executor.
3. press **execute**.
4. use **rightshift** to toggle the menu windows. the watermark stays visible!

### 2. for developers (using the library)
if you want to host the library yourself:
1. upload `shadowui.lua` to github/pastebin (raw).
2. load it in your script:
   ```lua
   local library = loadstring(game:HttpGet("your_raw_link_here"))()
   local ui = library:init("shadowui") -- initialize with your custom name
   ui:create_watermark() -- enable the permanent watermark
   
   local combat = ui:create_category("combat", UDim2.new(0, 50, 0, 60))
   combat:add_module("kill aura", function(v) print("aura toggled:", v) end)
   ```

---

## api documentation

### `library:init(name)`
initializes the library.
- `name`: the prefix for the watermark (e.g., "shadowui").

### `ui:create_watermark()`
enables the permanent, gradient watermark at the top-left.

### `ui:create_category(name, pos)`
creates a new draggable panel.
- `name`: the category name.
- `pos`: starting `UDim2` position.

### `category:add_module(name, callback)`
adds a module toggle. **right-click** the module to see its settings.

### `module:add_toggle(name, default, callback)`
adds a checkbox setting to a module.

### `module:add_slider(name, min, max, default, callback)`
adds a numerical slider setting to a module.

---

## keybinds
- **right shift:** toggle categories and blur effect.

---

## customization
the `client -> interface` module allows live adjustments of:
- **blur size**
- **transparency**
- **rainbow accent**
- **lowercase toggle**

---

## license
mit license - feel free to use, modify, and distribute.
