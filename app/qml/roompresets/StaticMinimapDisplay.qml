import QtQuick
import QtQuick.VectorImage
import labcompass
import '../point.js' as Point
import '..'

Item {
  id: root
  property var presetModel

  VectorImage {
    anchors.fill: parent
    source: root.presetModel && root.presetModel.areaCode ? 'qrc:/qt/qml/labcompass/assets/images/room-preset/' + root.presetModel.areaCode + '.svg' : ''
    width: 16
    height: 16
  }

  Repeater {
    id: exitDirectionView
    model: root.presetModel ? root.presetModel.doorExitLocations : []

    VectorImage {
      x: modelData.tileRect.x * root.width
      y: modelData.tileRect.y * root.height
      width: modelData.tileRect.width * root.width
      height: modelData.tileRect.height * root.height
      source: 'qrc:/qt/qml/labcompass/assets/images/compass/door-target.svg'
    }
  }

  Repeater {
    id: contentLocationsView
    model: root.presetModel ? root.presetModel.contentLocations: []

    VectorImage {
      x: modelData.tileRect.x * root.width
      y: modelData.tileRect.y * root.height
      width: modelData.tileRect.width * root.width
      height: modelData.tileRect.height * root.height
      source: 'qrc:/qt/qml/labcompass/assets/images/compass/loot-normal.svg'
    }
  }
}
