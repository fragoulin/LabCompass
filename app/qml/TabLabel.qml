import QtQuick 2.8
import labcompass

Item {
  id: root
  property alias text: text.text
  property bool active: true

  Text {
    id: text
    anchors.centerIn: parent
    font.pixelSize: 16
    color: root.active ? Global.primaryTextColor : Global.secondaryTextColor
  }
}
