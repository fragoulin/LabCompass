import QtQuick
import '..'

HighlightTab {
  id: root

  width: 48
  height: 24
  items: 2
  currentItem: 0

  activeLayerComponent: Row {
    Item {
      width: 24
      height: 24
      SvgImage {
        anchors.centerIn: parent
        source: 'qrc:/qt/qml/labcompass/assets/images/star-gold.svg'
      }
    }
    Item {
      width: 24
      height: 24
      SvgImage {
        anchors.centerIn: parent
        source: 'qrc:/qt/qml/labcompass/assets/images/map-marker-orange.svg'
      }
    }
  }

  inactiveLayerComponent: Row {
    Item {
      width: 24
      height: 24
      SvgImage {
        anchors.centerIn: parent
        source: 'qrc:/qt/qml/labcompass/assets/images/star-light.svg'
      }
    }
    Item {
      width: 24
      height: 24
      SvgImage {
        anchors.centerIn: parent
        source: 'qrc:/qt/qml/labcompass/assets/images/map-marker-light.svg'
      }
    }
  }
}
