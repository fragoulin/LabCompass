import QtQuick 2.8
import QtQuick.VectorImage
import '..'

Rectangle {
  id: root
  property var model

  Grid {
    anchors.horizontalCenter: parent.horizontalCenter
    horizontalItemAlignment: Grid.AlignHCenter
    padding: 10
    spacing: 16
    columns: 1
    Text {
      text: qsTr('Plan Summary')
      font.pixelSize: 26
      color: Global.primaryTextColor
    }
    Grid {
      rowSpacing: 12
      columnSpacing: 30
      columns: 2
      verticalItemAlignment: Grid.AlignVCenter
      Text { color: Global.primaryTextColor; text: qsTr('Rooms') }
      Text { color: Global.primaryTextColor; width: 30; horizontalAlignment: Text.AlignHCenter; text: model.rooms }
      Text { color: Global.primaryTextColor; text: qsTr('Length') }
      Text { color: Global.primaryTextColor; width: 30; horizontalAlignment: Text.AlignHCenter; text: model.length }
      // TODO make a custom component for the 4 Rows and Texts
      Row {
        spacing: 4
        VectorImage { source: 'qrc:/images/lab-content/argus.svg'; width: 16; height: 16 }
        Text { color: Global.primaryTextColor; text: qsTr('Argus') }
      }
      Text { color: Global.primaryTextColor; width: 30; horizontalAlignment: Text.AlignHCenter; text: model.argus }
      Row {
        spacing: 4
        VectorImage { source: 'qrc:/images/lab-content/gauntlet-puzzle.svg'; width: 16; height: 16 }
        Text { color: Global.primaryTextColor; text: qsTr('Trove/Lockbox') }
      }
      Text { color: 'white'; width: 30; horizontalAlignment: Text.AlignHCenter; text: model.troves }
      Row {
        spacing: 4
        VectorImage { source: 'qrc:/images/lab-content/darkshrine.svg'; width: 16; height: 16 }
        Text { color: Global.primaryTextColor; text: qsTr('Darkshrine') }
      }
      Text { color: 'white'; width: 30; horizontalAlignment: Text.AlignHCenter; text: model.darkshrines }
      Row {
        spacing: 4
        VectorImage { source: 'qrc:/images/lab-content/silver-door.svg'; width: 16; height: 16 }
        Text { color: Global.primaryTextColor; text: qsTr('Silver Cache') }
      }
      Text { color: Global.primaryTextColor; width: 30; horizontalAlignment: Text.AlignHCenter; text: model.silverCaches }
    }
  }
}
