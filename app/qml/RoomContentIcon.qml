import QtQuick 2.8
import labcompass
import QtQuick.Effects
import QtQuick.VectorImage

Item {
  id: root

  property string content

  width: 16
  height: 16
  visible: String(icon.source)

  VectorImage {
    id: icon
    anchors.fill: root
    source: root.content in Global.contentIconMapping ? 'qrc:/qt/qml/labcompass/assets/images/lab-content/' + Global.contentIconMapping[content] + '.svg' : ''
    width: 16
    height: 16
  }

  MultiEffect {
    source: icon
    anchors.fill: root
    shadowBlur: 2.0
    shadowEnabled: true
    shadowColor: "#80000000"
    shadowVerticalOffset: 1
  }
}
