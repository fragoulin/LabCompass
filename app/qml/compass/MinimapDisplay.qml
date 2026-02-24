import QtQuick 2.8
import QtQuick.VectorImage
import labcompass
import '../point.js' as Point
import '..'

Item {
  id: root
  property var instructionModel

  VectorImage {
    anchors.fill: parent
    source: 'qrc:/qt/qml/labcompass/assets/images/room-preset/' + root.instructionModel.preset.areaCode + '.svg'
    width: 16
    height: 16
  }

  Repeater {
    id: exitDirectionView
    model: root.instructionModel.doorExitLocations

    VectorImage {
      x: modelData.tileRect.x * root.width
      y: modelData.tileRect.y * root.height
      width: modelData.tileRect.width * root.width
      height: modelData.tileRect.height * root.height
      source: modelData.direction === instructionModel.nextRoomDirection ? 'qrc:/qt/qml/labcompass/assets/images/compass/door-target.svg'
                                                                         : 'qrc:/qt/qml/labcompass/assets/images/compass/door-normal.svg'
    }
  }

  Repeater {
    id: contentLocationsView
    model: root.instructionModel.contentLocations

    VectorImage {
      x: modelData.tileRect.x * root.width
      y: modelData.tileRect.y * root.height
      width: modelData.tileRect.width * root.width
      height: modelData.tileRect.height * root.height
      source: root.instructionModel.nextRoomConnectionType === 'secret' && !modelData.major ? 'qrc:/qt/qml/labcompass/assets/images/compass/loot-target.svg'
                                                                                       : 'qrc:/qt/qml/labcompass/assets/images/compass/loot-normal.svg'
    }
  }

  Item {
    width: 36
    height: 16
    anchors.bottom: parent.bottom

    RoomContentView {
      anchors.centerIn: parent
      model: root.instructionModel.roomLoot
    }
  }
}
