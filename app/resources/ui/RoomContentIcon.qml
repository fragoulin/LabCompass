import QtQuick 2.8
import com.labcompass 1.0
import QtQuick.Effects

Item {
  id: root

  property string content

  width: 16
  height: 16
  visible: String(icon.source)

  SvgImage {
    id: icon
    anchors.fill: parent
    source: content in Global.contentIconMapping ? 'qrc:/images/lab-content/' + Global.contentIconMapping[content] + '.svg' : ''
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
