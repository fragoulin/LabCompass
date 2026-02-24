import QtQuick 2.8
import labcompass
import '..'

ToolbarButton {
  id: root

  width: 24
  height: 24
  source: 'qrc:/qt/qml/labcompass/assets/images/view-list-light.svg'
  active: Global && Global.roomPresetsWindowOpen
  onClicked: {
    if (Global) {
      var open = Global.roomPresetsWindowOpen;
      closeAllWindows();
      if (!open)
        Global.roomPresetsWindowOpen = true;
    }
  }

  function closeAllWindows() {
    Global.plannerWindowOpen = false;
    Global.puzzleWindowOpen = false;
    Global.optionsWindowOpen = false;
    Global.roomPresetsWindowOpen = false;
  }
}
