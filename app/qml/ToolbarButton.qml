import QtQuick 2.8
import com.labcompass 1.0
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
    anchors.centerIn: parent
    width: 16
    height: 16
  }
  MaterialInk {
    anchors.fill: parent
    onClicked: root.clicked()
  }
}
