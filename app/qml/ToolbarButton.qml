import QtQuick
import labcompass

Rectangle {
  id: root
  property string source
  property bool active
  signal clicked()

  implicitWidth: 24
  implicitHeight: 24
  color: active ? Global.lightPrimaryColor : Global.backgroundColor
  SvgImage {
    source: root.source
    anchors.centerIn: root
  }
  MaterialInk {
    anchors.fill: root
    onClicked: root.clicked()
  }
}
