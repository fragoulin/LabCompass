import QtQuick
import labcompass
import '..'

Rectangle {
  id: root
  property string roomName
  property var roomContents: []

  x: -width / 2 + parent.width / 2
  y: -height - 36 + parent.height / 2
  width: grid.width
  height: grid.height
  color: Qt.rgba(0, 0, 0, 0.8)
  Grid {
    id: grid
    padding: 10
    spacing: 16
    columns: 1
    horizontalItemAlignment: Grid.AlignHCenter
    Text {
      color: Styles.primaryTextColor
      text: root.roomName
    }
    Grid {
      spacing: 2
      columns: 1
      horizontalItemAlignment: Grid.AlignHCenter
      Repeater {
        model: root.roomContents
        Row {
          spacing: 2
          required property var modelData
          SvgImage {
            source: parent.modelData in Global.contentIconMapping ? 'qrc:/qt/qml/labcompass/assets/images/lab-content/' + Global.contentIconMapping[parent.modelData] + '.svg' : ''
          }
          Text {
            text: parent.modelData in Global.nameMapping ? Global.nameMapping[parent.modelData] : parent.modelData
            color: Styles.primaryTextColor
            font.pixelSize: 14
          }
        }
      }
    }
  }
  Rectangle {
    x: 10
    y: 36
    width: grid.width - 20
    height: 1
    color: Qt.lighter(Styles.primaryColor)
    visible: root.roomContents.length
  }
}
