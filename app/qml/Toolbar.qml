import QtQuick
import labcompass

Column {
  id: root
  spacing: 4

  ToolbarButton {
    implicitHeight: 40
    source: 'qrc:/qt/qml/labcompass/assets/images/navigation-light.svg'
    active: Global && Global.plannerWindowOpen
    onClicked: {
      if (Global) {
        var open = Global.plannerWindowOpen;
        closeAllWindows();
        if (!open)
          Global.plannerWindowOpen = true;
      }
    }
    NotificationIndicator {
      visible: !Global.loadedMapUpToDate
    }
  }

  ToolbarButton {
    implicitHeight: 40
    source: 'qrc:/qt/qml/labcompass/assets/images/puzzle-light.svg'
    active: Global && Global.puzzleWindowOpen
    onClicked: {
      if (Global) {
        var open = Global.puzzleWindowOpen;
        closeAllWindows();
        if (!open)
          Global.puzzleWindowOpen = true;
      }
    }
  }

  ToolbarButton {
    implicitHeight: 40
    source: 'qrc:/qt/qml/labcompass/assets/images/settings-light.svg'
    active: Global && Global.optionsWindowOpen
    onClicked: {
      if (Global) {
        var open = Global.optionsWindowOpen;
        closeAllWindows();
        if (!open)
          Global.optionsWindowOpen = true;
      }
    }
    NotificationIndicator {
      visible: Global.model.newVersionAvailable
    }
  }

  function closeAllWindows() {
    Global.plannerWindowOpen = false;
    Global.puzzleWindowOpen = false;
    Global.optionsWindowOpen = false;
    Global.roomPresetsWindowOpen = false;
  }
}
