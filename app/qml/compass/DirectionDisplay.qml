import QtQuick 2.8
import labcompass
import '..'

Item {
  id: root
  property var instructionModel

  Item {
    anchors.centerIn: parent

    Repeater {
      id: exitDirectionView
      model: root.instructionModel.doorExitLocations
      anchors.centerIn: parent

      Rectangle {
        x: Global.directionMapping[modelData.direction].dx * 48 - width / 2
        y: Global.directionMapping[modelData.direction].dy * 48 - height / 2
        width: 16
        height: 16
        radius: 8
        color: modelData.direction === root.instructionModel.nextRoomDirection ? Global.activePathColor : '#909090'
        border {
          width: 1
          color: 'black'
        }
      }
    }

    Repeater {
      id: contentLocationsView
      model: root.instructionModel.contentLocations

      Rectangle {
        x: Global.directionMapping[modelData.direction].dx * 30 - width / 2
        y: Global.directionMapping[modelData.direction].dy * 30 - height / 2
        width: 8
        height: 8
        rotation: 45
        color: root.instructionModel.nextRoomConnectionType === 'secret' && !modelData.major ? Global.activePathColor : '#FFA726'
        border {
          width: 1
          color: 'black'
        }
      }
    }

    RoomContentView {
      anchors.centerIn: parent
      model: root.instructionModel.roomLoot
    }
  }
}
