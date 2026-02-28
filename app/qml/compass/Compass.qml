import QtQuick
import QtQuick.VectorImage
import labcompass
import '..'

Item {
  id: root

  implicitWidth: useMinimapDisplay ? minimapDisplay.implicitWidth : directionDisplay.implicitWidth + 40
  implicitHeight: useMinimapDisplay ? minimapDisplay.implicitHeight : directionDisplay.implicitHeight

  property bool displayActive: Global.model.inLab && Global.model.currentRoomDetermined
  property bool useMinimapDisplay: Global.model.settings.showMinimap && displayActive && Object.keys(Global.model.instructionModel.preset).length
  property bool compassToolbarVisible: Global.compassToolbarVisible

  Item {
    id: directionDisplay
    implicitWidth: 170
    implicitHeight: 170
    anchors.right: parent.right
    visible: !root.useMinimapDisplay

    VectorImage {
      id: directionHud
      anchors.fill: directionDisplay
      source: 'qrc:/qt/qml/labcompass/assets/images/compass/direction-hud.svg'
      width: 16
      height: 16
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

    VectorImage {
      anchors.fill: minimapDisplay
      source: 'qrc:/qt/qml/labcompass/assets/images/compass/minimap-hud.svg'
      width: 16
      height: 16
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
    visible: root.compassToolbarVisible
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
    target: logWatcher
    ignoreUnknownSignals: true
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
}
