import QtQuick

Row {
  id: root
  spacing: 4

  readonly property alias titleBar: titleBar
  readonly property alias closeButton: closeButton

  signal exit()

  Rectangle {
    id: titleBar
    objectName: "titleBar"
    width: text.implicitWidth + closeButton.width
    height: 24
    color: Global.lightPrimaryColor
    Text {
      id: text
      text: 'LabCompass'
      color: Global.primaryTextColor
      anchors.centerIn: parent
    }
  }

  ToolbarButton {
    id: closeButton
    objectName: "closeButton"
    source: 'qrc:/qt/qml/labcompass/assets/images/close.svg'
    onClicked: root.exit()
  }
}
