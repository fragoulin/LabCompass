import QtQuick 2.8
import QtQuick.VectorImage
import com.labcompass 1.0
import '../point.js' as Point
import '..'

Item {
  id: root
  property var instructionModel

  VectorImage {
    anchors.fill: parent
    source: 'qrc:/labcompass/assets/images/room-preset/' + instructionModel.preset.areaCode + '.svg'
    width: 16
    height: 16
  }

  Repeater {
    id: exitDirectionView
    model: instructionModel.doorExitLocations

    VectorImage {
      x: modelData.tileRect.x * root.width
      y: modelData.tileRect.y * root.height
      width: modelData.tileRect.width * root.width
      height: modelData.tileRect.height * root.height
      source: modelData.direction === instructionModel.nextRoomDirection ? 'qrc:/labcompass/assets/images/compass/door-target.svg'
                                                                         : 'qrc:/labcompass/assets/images/compass/door-normal.svg'
    }
  }

  Repeater {
    id: contentLocationsView
    model: instructionModel.contentLocations

    VectorImage {
      x: modelData.tileRect.x * root.width
      y: modelData.tileRect.y * root.height
      width: modelData.tileRect.width * root.width
      height: modelData.tileRect.height * root.height
      source: instructionModel.nextRoomConnectionType === 'secret' && !modelData.major ? 'qrc:/labcompass/assets/images/compass/loot-target.svg'
                                                                                       : 'qrc:/labcompass/assets/images/compass/loot-normal.svg'
    }
  }

  Item {
    width: 36
    height: 16
    anchors.bottom: parent.bottom

    RoomContentView {
      anchors.centerIn: parent
      model: instructionModel.roomLoot
    }
  }
}
