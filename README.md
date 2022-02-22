# The Script Is Fully Working Now - Already Added Some Enhancements
<h1 align='center'>Follow The New Version From The Link Below</h1>
<h2 align='center'><a href='https://github.com/mahanmoulaei/JLRP-VehicleRemote'>LINK TO NEW VERSION</a></h2>

* If you are a mechanic and want to make a copy of the keys use this trigger
```LUA
TriggerServerEvent('Boost-Locksystem:CreateKeyCopy', plate)
```
* If you want to auto add key on purchase use this trigger
```LUA
TriggerServerEvent('Boost-Locksystem:AddKeys', plate)
```
or
```LUA
TriggerClientEvent('Boost-Locksystem:AddKeysOfTheVehiclePedIsIn', source) --this will add the key for the vehicle player is sitting in
```
* If you want to remove the key use this trigger
```LUA
TriggerServerEvent('Boost-Locksystem:RemoveKey', plate)
```

<table align='center'>
	<tr>
		<td  align='center'>
			Car Key System for <a href='https://github.com/esx-framework/esx-legacy'>ESX-Legacy</a> and <a href='https://github.com/overextended/ox_inventory'>OX_Inventory</a>
		</td>
	</tr>
	<tr>
		<td>
			This resource is a fork of <a href='https://github.com/boostless/Boost-Locksystem'>Boost-Locksystem</a> (<a href='https://forum.cfx.re/t/release-esx-boosts-lock-system-with-metadata/4531012'>FiveM forum post</a>)
		</td>
	</tr>
</table>
