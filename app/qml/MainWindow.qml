import QtQuick
import labcompass
import "compass"
import "instruction"
import QWindowKit

Window {
  id: window
  objectName: "MainWindow"
  minimumWidth: Math.max(header.implicitWidth, compass.implicitWidth + toolbar.implicitWidth, instructionList.implicitWidth)
  minimumHeight: header.implicitHeight + compass.implicitHeight + instructionList.implicitHeight
  maximumWidth: minimumWidth
  maximumHeight: minimumHeight
  color: "transparent"
  visible: false
  flags: Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint

  Component.onCompleted: {
    windowAgent.setup(window)
    setWindowPosition()
    window.visible = true
  }

  WindowAgent {
    id: windowAgent
  }

  Column {
    anchors.right: parent.right
    spacing: 4

    Header {
      id: header
      anchors.right: parent.right
      Component.onCompleted: {
        windowAgent.setTitleBar(header.titleBar)
        windowAgent.setHitTestVisible(header.closeButton);
        windowAgent.setSystemButton(WindowAgent.Close, header.closeButton);
      }
      onExit: window.close()
    }

    Row {
      anchors.right: parent.right
      Compass {
        id: compass
      }
      Toolbar {
        id: toolbar
      }
    }

    InstructionList {
      id: instructionList
      anchors.right: parent.right
    }
  }

  function setWindowPosition() {
    const mainWindowPosition = Global.model.settings.mainWindowPosition
    if (mainWindowPosition.x < window.screen.width & mainWindowPosition.y < window.screen.height) {
      window.x = mainWindowPosition.x
      window.y = mainWindowPosition.y
    } else {
      windowAgent.centralize()
    }
  }

  Connections {
    target: Global
    function onCompassVisibleChanged() {
      window.visible = Global.compassVisible;
    }
  }
}
