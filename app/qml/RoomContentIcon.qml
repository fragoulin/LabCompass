import QtQuick
import labcompass
import QtQuick.Effects

Item {
  id: root

  property string content

  width: 16
  height: 16
  visible: String(icon.source)

  SvgImage {
    id: icon
    anchors.fill: root
    source: root.content in Global.contentIconMapping ? 'qrc:/qt/qml/labcompass/assets/images/lab-content/' + Global.contentIconMapping[content] + '.svg' : ''
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
