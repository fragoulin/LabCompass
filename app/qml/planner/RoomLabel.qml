import QtQuick 2.8
import QtQuick.VectorImage
import labcompass
import '..'

Rectangle {
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
      color: Global.primaryTextColor
      text: roomName
    }
    Grid {
      spacing: 2
      columns: 1
      horizontalItemAlignment: Grid.AlignHCenter
      Repeater {
        model: roomContents
        Row {
          spacing: 2
          VectorImage {
            source: modelData in Global.contentIconMapping ? 'qrc:/qt/qml/labcompass/assets/images/lab-content/' + Global.contentIconMapping[modelData] + '.svg' : ''
            width: 16
            height: 16
          }
          Text {
            text: modelData in Global.nameMapping ? Global.nameMapping[modelData] : modelData
            color: Global.primaryTextColor
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
    color: Qt.lighter(Global.primaryColor)
    visible: roomContents.length
  }
}
