import QtQuick
import QtQuick.VectorImage
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
      VectorImage {
        anchors.centerIn: parent
        source: 'qrc:/qt/qml/labcompass/assets/images/star-gold.svg'
        width: 16
        height: 16
      }
    }
    Item {
      width: 24
      height: 24
      VectorImage {
        anchors.centerIn: parent
        source: 'qrc:/qt/qml/labcompass/assets/images/map-marker-orange.svg'
        width: 16
        height: 16
      }
    }
  }

  inactiveLayerComponent: Row {
    Item {
      width: 24
      height: 24
      VectorImage {
        anchors.centerIn: parent
        source: 'qrc:/qt/qml/labcompass/assets/images/star-light.svg'
        width: 16
        height: 16
      }
    }
    Item {
      width: 24
      height: 24
      VectorImage {
        anchors.centerIn: parent
        source: 'qrc:/qt/qml/labcompass/assets/images/map-marker-light.svg'
        width: 16
        height: 16
      }
    }
  }
}
