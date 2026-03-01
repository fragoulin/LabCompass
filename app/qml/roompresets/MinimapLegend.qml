import QtQuick
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
      //: Legend label title displayed in room presets. Label should be brief because of limited space available
      //% "Legend"
      //@ RoomPresets
      text: qsTrId("id-roompresets-legend")
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
      Text {
        color: Global.primaryTextColor;
        //: Path label caption displayed in room presets. Label should be brief because of limited space available
        //% "Path"
        //@ RoomPresets
        text: qsTrId("id-roompresets-path")
      }

      VectorImage { width: 26; height: 20; source: 'qrc:/qt/qml/labcompass/assets/images/compass/tile-trap.svg' }
      Text {
        color: Global.primaryTextColor;
        //: Traps label caption displayed in room presets. Label should be brief because of limited space available
        //% "Traps"
        //@ RoomPresets
        text: qsTrId("id-roompresets-traps")
      }

      VectorImage { width: 26; height: 20; source: 'qrc:/qt/qml/labcompass/assets/images/compass/door-target.svg' }
      Text {
        color: Global.primaryTextColor;
        //: Exit label caption displayed in room presets. Label should be brief because of limited space available
        //% "Exit"
        //@ RoomPresets
        text: qsTrId("id-roompresets-exit")
      }

      VectorImage { width: 26; height: 20; source: 'qrc:/qt/qml/labcompass/assets/images/compass/loot-normal.svg' }
      Text {
        color: Global.primaryTextColor;
        //: Loot label caption displayed in room presets. Label should be brief because of limited space available
        //% "Loot"
        //@ RoomPresets
        text: qsTrId("id-roompresets-loot")
      }
    }
  }
}
