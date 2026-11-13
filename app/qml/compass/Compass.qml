import QtQuick
import labcompass
import common

Item {
  id: root
  objectName: "compass"

  implicitWidth: useMinimapDisplay ? minimapDisplay.implicitWidth : directionDisplay.implicitWidth + 40
  implicitHeight: useMinimapDisplay ? minimapDisplay.implicitHeight : directionDisplay.implicitHeight

  required property bool showMinimap
  required property LogWatcher logWatcher
  required property var hotkey

  property bool displayActive: Global.model.inLab && Global.model.currentRoomDetermined
  property bool useMinimapDisplay: showMinimap && displayActive && Object.keys(Global.model.instructionModel.preset).length

  visible: Global.model.logFileOpen

  Item {
    id: directionDisplay
    implicitWidth: 170
    implicitHeight: 170
    anchors.right: parent.right
    visible: !root.useMinimapDisplay

    SvgImage {
      id: directionHud
      objectName: "directionHud"
      anchors.fill: directionDisplay
      source: 'qrc:/qt/qml/labcompass/assets/images/compass/direction-hud.svg'
    }

    Loader {
      anchors.fill: directionDisplay
      active: !root.useMinimapDisplay && root.displayActive
      sourceComponent: DirectionDisplay {
        instructionModel: Global.model.instructionModel
      }
    }
  }

  Item {
    id: minimapDisplay
    implicitWidth: 210
    implicitHeight: 170
    anchors.fill: parent
    visible: root.useMinimapDisplay

    SvgImage {
      id: minimapHud
      anchors.fill: minimapDisplay
      source: 'qrc:/qt/qml/labcompass/assets/images/compass/minimap-hud.svg'
    }

    Loader {
      width: 182
      height: 140
      anchors.centerIn: parent
      active: root.useMinimapDisplay
      sourceComponent: MinimapDisplay {
        instructionModel: Global.model.instructionModel
      }
    }
  }

  CompassToolbar {
    objectName: "compassToolbar"
    visible: root.visible && Global.model && Global.model.roomPresetModel ? Global.model.roomPresetModel.presets.length : false
    x: 172
    y: 132
  }

  Rectangle {
    id: timerView
    color: '#88000000'
    x: 150
    y: 10
    width: timerViewText.implicitWidth
    height: timerViewText.implicitHeight
    visible: false
    Text {
      id: timerViewText
      anchors.centerIn: parent
      text: '00:00'
      color: 'white'
    }
    Timer {
      id: timer
      property double startTime
      interval: 100
      repeat: true
      triggeredOnStart: true
      onTriggered: {
        var elapsed = Date.now() - timer.startTime;
        timerViewText.text = ('00'+Math.floor(elapsed/60000)).slice(-2) + ':' + ('00'+Math.floor(elapsed%60000/1000)).slice(-2);
      }
    }
  }

  function restartTimer() {
    timer.startTime = Date.now();
    timer.restart();
    timerView.visible = true;
  }
  function stopTimer() {
    timer.stop();
  }
  function closeTimer() {
    stopTimer();
    timerView.visible = false;
  }

  Connections {
    target: root.logWatcher
    function onLabStarted() {
      root.restartTimer()
    }
    function onLabFinished() {
      root.stopTimer()
    }
    function onLabExit() {
      root.closeTimer()
    }
  }

  Connections {
    target: root.hotkey
    function onActivated() {
      if (Global.model.logFileOpen) {
        root.visible = !root.visible
      }
    }
  }
}
