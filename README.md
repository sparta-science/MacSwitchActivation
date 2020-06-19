# MacSwitchActivation
Demo of SetActivationPolicy bug on Mac

### Expected behaviour

When we set activation policy to regular app we want the app to be able to become active with key window and showing menu.

`NSApp.setActivationPolicy(.regular)`

### Actual behaviour

When we switch to regular app we see menu of the previous top app in the menu bar. And even we tell the app to activate:
```
        NSApp.activate(ignoringOtherApps: true)
```
it activates without our menu.

To workaround user have to switch to another app temporarily and switch back to our app to get menu showing.



### Steps to reproduce

1. Launch the app
2. Notice the main window showing with proper main menu
3. Close window
4. Notice app changes to accessory and hides the app in the dock
5. Restart the app
6. Notice it starts as accessory with dock icon hiding
7. Click on Menu bar button (looks like a house)
8. Select Show Window in the menu dropdown
9. Notice Window appears but no menu
10. Cmd-tab to another app and back brings the menu
