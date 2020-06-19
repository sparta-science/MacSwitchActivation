# MacSwitchActivation
Demo of SetActivationPolicy bug on Mac

### Expected behaviour
When we click `Show Window` we expect the app to enter "Active State"

### Actual behaviour

When we click `Show Window` we instead see the app enter "Unexpected State" (See Reproduction Steps)

To workaround the user has to switch to another app temporarily and switch back to our app to get menu showing.

### App States
##### Active State: 
* App name appears in the menu bar
* App Window is on top
* App appears in dock

Active State is entered by:
`House Icon` -> `Show Window` which should run
```
NSApp.activate(ignoringOtherApps: true)
NSApp.setActivationPolicy(.regular)
```

##### Accessory State:
* App name does not appear in the menu bar
* No App Window is visible
* App does not appear in dock

Accessory State is entered by closing the app window which triggers `NSApp.setActivationPolicy(.accessory)`

##### Unexpected State:
* The previous active app name appears in the menu bar
* App Window is on top
* App does not appear in dock


### Steps to reproduce

1. Launch the app to begin in "Active State"
2. Close app window to enter "Accessory State"
3. Restart the app to begin in "Accessory State"
4. Attempt to enter "Active State" by selecting `Show Window` in the menu dropdown
5. Notice the new "Unexpected State"
6. Cmd-tab to another app and back brings the menu and name in top left corner
