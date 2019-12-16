# i18n
Internationalization framework for onset packages

## Example

packages/your_package/i18n/en.json
```json
{
  "player_join": "{1} joined the server!",
  "player_quit": "{1} left the server!"
}
```
packages/your_package/script.lua
```lua
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
AddEvent("OnPlayerJoin", function(player)
  AddPlayerChatAll(_("player_join", GetPlayerName(player)))
end)
AddEvent("OnPlayerQuit", function(player)
  AddPlayerChatAll(_("player_quit", GetPlayerName(player)))
end)
```

## Config
By default it uses "en" as language. To select another language for your server you have to create a config.  
i18n.json
```json
{
  "language": "de"
}
```
In case the server language doesn't exist for a package it falls back to en.
Per player translations aren't implemented yet but i might implement it in the future if s.b. needs this feature.

## Events
On the client-side it takes a moment to download the translations.
Once the translations are ready the event `OnTranslationReady` is fired. (on the server-side with the player as param)
