# The Script Is Fully Working Now - Already Added Some Enhancements
# WILL ADD SOME MORE ENHANCEMENTS AND FEATURES(WIP)

* If you are a mechanic and want to make a copy of the keys use this trigger
```LUA
TriggerServerEvent('JL-LockSystem:CreateKeyCopy', plate)
```
* If you want to auto add key on purchase use this trigger
```LUA
TriggerServerEvent('JL-LockSystem:AddKeys', plate)
```
or
```LUA
TriggerClientEvent('JL-LockSystem:AddKeysOfTheVehiclePedIsIn', source) --this will add the key for the vehicle player is sitting in
```
* If you want to remove the key use this trigger
```LUA
TriggerServerEvent('JL-LockSystem:RemoveKey', plate)
```

<br><br><br><h3 align='center'>Legal Notices</h2>
<table><tr><td>
Car Key System for <a href='https://github.com/esx-framework/esx-legacy'>ESX-Legacy</a> and <a href='https://github.com/overextended/ox_inventory'>OX_Inventory</a>
 
MIT License

Copyright (c) 2021-2022 boostless

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
</td></tr>
<tr><td>
This resource is a derivative of <a href='https://github.com/boostless/Boost-Locksystem'>Boost-Locksystem</a>(<a href='https://forum.cfx.re/t/release-esx-boosts-lock-system-with-metadata/4531012'>FiveM Forum Post</a>).
</td></td></table>
