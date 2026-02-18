import QtQuick 2.8
import com.labcompass 1.0

Rectangle {
  id: root
  property string source
  property bool active
  signal clicked()

  implicitWidth: image.implicitWidth
  implicitHeight: image.implicitHeight
  color: active ? Global.lightPrimaryColor : Global.backgroundColor
  SvgImage {
    id: image
    source: root.source
    anchors.centerIn: parent
    sourceSize.width: 24
    sourceSize.height: 24
  }
  MaterialInk {
    anchors.fill: parent
    onClicked: root.clicked()
  }
}
