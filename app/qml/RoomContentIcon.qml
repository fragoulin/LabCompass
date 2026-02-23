import QtQuick 2.8
import com.labcompass 1.0
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
    anchors.fill: parent
    source: content in Global.contentIconMapping ? 'qrc:/labcompass/assets/images/lab-content/' + Global.contentIconMapping[content] + '.svg' : ''
    width: 16
    height: 16
  }

  MultiEffect {
    source: icon
    anchors.fill: parent
    shadowBlur: 2.0
    shadowEnabled: true
    shadowColor: "#80000000"
    shadowVerticalOffset: 1
  }
}
