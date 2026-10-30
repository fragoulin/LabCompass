import QtQuick
import labcompass
import '../point.js' as Point
import '..'

Item {
  id: root
  property var presetModel

  SvgImage {
    anchors.fill: parent
    source: root.presetModel && root.presetModel.areaCode ? 'qrc:/qt/qml/labcompass/assets/images/room-preset/' + root.presetModel.areaCode + '.svg' : ''
  }

  Repeater {
    id: exitDirectionView
    model: root.presetModel ? root.presetModel.doorExitLocations : []

    SvgImage {
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

    SvgImage {
      x: modelData.tileRect.x * root.width
      y: modelData.tileRect.y * root.height
      width: modelData.tileRect.width * root.width
      height: modelData.tileRect.height * root.height
      source: 'qrc:/qt/qml/labcompass/assets/images/compass/loot-normal.svg'
    }
  }
}
