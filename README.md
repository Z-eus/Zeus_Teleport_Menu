# Zeus Teleport Menu
This script allows you to register and manage different teleport locations on your RedM server.
The script allows users to register teleport locations, view registered locations, teleport to those locations, rename or delete locations.
You can open the Teleport Menu with the /tpmenu command and add new locations and edit existing ones.
The `config.lua` file allows you to configure whether the menu can be accessed by anyone or with what authorization, and which command can be used to open the menu.

## Installation
- Throw it into your `resources` folder
- Add `ensure Zeus_Teleport_Menu` to your `server.cfg`
- Run `tp_menu_locations.sql` file

## NOTE
- Dependency `VORP Core` & `vorp_menu` & `vorp_inputs` & `oxmysql`