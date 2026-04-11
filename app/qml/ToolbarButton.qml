import QtQuick
import labcompass

Rectangle {
  id: root
  property string source
  property bool active
  signal clicked()

  implicitWidth: image.implicitWidth
  implicitHeight: image.implicitHeight
  color: active ? Global.lightPrimaryColor : Global.backgroundColor
  SvgImage {
    source: root.source
    anchors.centerIn: root
    sourceSize.width: 24
    sourceSize.height: 24
  }
  MaterialInk {
    anchors.fill: root
    onClicked: root.clicked()
  }
}
