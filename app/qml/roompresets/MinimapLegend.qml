import QtQuick 2.8
import QtQuick.VectorImage
import labcompass
import '..'

Item {
  id: root
  width: grid.width
  height: grid.height

  Rectangle {
    anchors.fill: parent
    color: Global.primaryColor
  }

  Grid {
    id: grid
    anchors.centerIn: parent
    columns: 1
    spacing: 16
    leftPadding: 20
    rightPadding: 20
    topPadding: 12
    bottomPadding: 12
    horizontalItemAlignment: Grid.AlignHCenter

    Text {
      font.pixelSize: 20
      color: Global.primaryTextColor
      text: qsTr('Legend')
    }

    Grid {
      columns: 2
      horizontalItemAlignment: Grid.AlignHCenter
      verticalItemAlignment: Grid.AlignVCenter
      rowSpacing: 12
      columnSpacing: 20

      Row {
        spacing: 2
        VectorImage { width: 26; height: 20; source: 'qrc:/qt/qml/labcompass/assets/images/compass/tile-full.svg' }
        VectorImage { width: 26; height: 20; source: 'qrc:/qt/qml/labcompass/assets/images/compass/tile-cross.svg' }
      }
      Text { color: Global.primaryTextColor; text: qsTr('Path') }

      VectorImage { width: 26; height: 20; source: 'qrc:/qt/qml/labcompass/assets/images/compass/tile-trap.svg' }
      Text { color: Global.primaryTextColor; text: qsTr('Traps') }

      VectorImage { width: 26; height: 20; source: 'qrc:/qt/qml/labcompass/assets/images/compass/door-target.svg' }
      Text { color: Global.primaryTextColor; text: qsTr('Exit') }

      VectorImage { width: 26; height: 20; source: 'qrc:/qt/qml/labcompass/assets/images/compass/loot-normal.svg' }
      Text { color: Global.primaryTextColor; text: qsTr('Loot') }
    }
  }
}
