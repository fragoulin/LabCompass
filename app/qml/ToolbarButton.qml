import QtQuick
import labcompass
import QtQuick.VectorImage

Rectangle {
  id: root
  property string source
  property bool active
  property double buttonHeight: 40
  signal clicked()

  width: 24
  height: root.buttonHeight

  color: active ? Global.lightPrimaryColor : Global.backgroundColor
  VectorImage {
    source: root.source
    anchors.centerIn: root
    width: 16
    height: 16
  }
  MaterialInk {
    anchors.fill: root
    onClicked: root.clicked()
  }
}
