import QtQuick
import labcompass

Rectangle {
  id: root
  property string source
  property bool active
  property double buttonHeight: 40
  signal clicked()

  width: 24
  height: root.buttonHeight

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
