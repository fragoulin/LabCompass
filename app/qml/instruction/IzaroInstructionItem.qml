import QtQuick
import labcompass
import '..'

InstructionItem {
  id: root

  property string mechanics

  Text {
    //: Instruction displayed when the player is ready to face Izaro
    //% "Defeat Izaro"
    //@ Instruction
    text: qsTrId("id-defeat-izaro")
    color: Global.primaryTextColor
  }
  Row {
    visible: root.mechanics
    spacing: 4
    SvgImage {
      source: 'qrc:/qt/qml/labcompass/assets/images/instruction/mechanics.svg'
    }
    Text {
      text: root.mechanics in Global.nameMapping ? Global.nameMapping[mechanics] : root.mechanics
      color: Global.primaryTextColor
    }
  }

  iconComponent: Item {
    id: izaroInstructionItemIcon
    objectName: 'izaroInstructionItemIcon'

    SvgImage {
      anchors.centerIn: parent
      visible: izaroInstructionItemIcon.state === ''
      source: root.mechanics === 'ChargeDisruptors' || root.mechanics === 'Idols' ? 'qrc:/qt/qml/labcompass/assets/images/instruction/izaro-wait.svg'
                                                                                  : 'qrc:/qt/qml/labcompass/assets/images/instruction/izaro-kill.svg'
      sourceSize.width: 20
      sourceSize.height: 20
    }

    property real countdownStart: 0
    property real countdownEnd: 0
    property real currentTime: 0
    CircleProgressBar {
      anchors.centerIn: parent
      visible: izaroInstructionItemIcon.state === 'countdownRunning'
      width: 30
      height: 30
      color: '#FDD835'
      circleWidth: 2
      value: (izaroInstructionItemIcon.countdownEnd - izaroInstructionItemIcon.currentTime) / (izaroInstructionItemIcon.countdownEnd - izaroInstructionItemIcon.countdownStart)
      Text {
        anchors.centerIn: parent
        text: Math.ceil((izaroInstructionItemIcon.countdownEnd - izaroInstructionItemIcon.currentTime) / 1000)
        color: '#FDD835'
        font.family: 'Open Sans'
        font.pixelSize: 14
      }
    }
    Timer {
      running: izaroInstructionItemIcon.state === 'countdownRunning'
      interval: 50
      repeat: true
      triggeredOnStart: true
      onTriggered: {
        izaroInstructionItemIcon.currentTime = Date.now();
        if (izaroInstructionItemIcon.currentTime > izaroInstructionItemIcon.countdownEnd)
          izaroInstructionItemIcon.state = 'countdownFinished';
      }
    }

    SvgImage {
      anchors.centerIn: parent
      visible: izaroInstructionItemIcon.state === 'countdownFinished'
      source: 'qrc:/qt/qml/labcompass/assets/images/instruction/izaro-kill.svg'
      sourceSize.width: 20
      sourceSize.height: 20

      SequentialAnimation on opacity {
        loops: Animation.Infinite
        running: true
        NumberAnimation { from: 1; to: 0; duration: 200; easing.type: Easing.InQuad }
        NumberAnimation { from: 0; to: 1; duration: 200; easing.type: Easing.OutQuad }
      }
    }

    states: [
      State {
        name: 'countdownRunning'
        StateChangeScript {
          script: {
            if (!(root.mechanics === 'ChargeDisruptors' || root.mechanics === 'Idols'))
              return;

            var delay = root.mechanics === 'ChargeDisruptors' ? 29 : 27;
            countdownStart = Date.now();
            countdownEnd = countdownStart + delay * 1000;
            currentTime = countdownStart;
          }
        }
      },
      State { name: 'countdownFinished' }
    ]

    function onIzaroBattleStarted() {
      if (root.mechanics === 'ChargeDisruptors' || root.mechanics === 'Idols')
        state = 'countdownRunning';
    }
  }
}
