import QtQuick
import '..'

Rectangle {
  id: root
  property var model
  // No padding and spacing for korean and thai languages
  readonly property bool noPadding: Global.model.settings.languageCode == "th" || Global.model.settings.languageCode == "ko"

  Grid {
    anchors.horizontalCenter: parent.horizontalCenter
    horizontalItemAlignment: Grid.AlignHCenter
    padding: root.noPadding ? 0 : 10
    spacing: root.noPadding ? 0 : 16
    columns: 1
    Text {
      //: Label for plan summary displayed in the planner window. Label should be brief because of limited space
      //% "Plan Summary"
      //@ Planner
      text: qsTrId("id-plan-summary")
      font.pixelSize: 26
      color: Styles.primaryTextColor
    }
    Grid {
      rowSpacing: 12
      columnSpacing: 30
      columns: 2
      verticalItemAlignment: Grid.AlignVCenter
      Text {
        color: Styles.primaryTextColor;
        //: Room label in planner window's caption. Label should be brief because of limited space
        //% "Rooms"
        //@ Planner
        text: qsTrId("id-planner-rooms")
      }
      Text { color: Styles.primaryTextColor; width: 30; horizontalAlignment: Text.AlignHCenter; text: root.model.rooms }
      Text {
        color: Styles.primaryTextColor;
        //: Length label in planner window's caption. This is the number of rooms in the labyrinth. Label should be brief because of limited space
        //% "Length"
        //@ Planner
        text: qsTrId("id-planner-length") }
      Text { color: Styles.primaryTextColor; width: 30; horizontalAlignment: Text.AlignHCenter; text: root.model.length }
      // TODO make a custom component for the 4 Rows and Texts
      Row {
        spacing: 4
        SvgImage { source: 'qrc:/qt/qml/labcompass/assets/images/lab-content/argus.svg'; anchors.verticalCenter: parent.verticalCenter }
        Text {
          color: Styles.primaryTextColor;
          //: Argus label in planner window's caption. Label should be brief because of limited space
          //% "Argus"
          //@ Planner
          text: qsTrId("id-planner-argus")
        }
      }
      Text { color: Styles.primaryTextColor; width: 30; horizontalAlignment: Text.AlignHCenter; text: root.model.argus }
      Row {
        spacing: 4
        SvgImage { source: 'qrc:/qt/qml/labcompass/assets/images/lab-content/gauntlet-puzzle.svg'; anchors.verticalCenter: parent.verticalCenter }
        Text {
          color: Styles.primaryTextColor;
          //: Trove/Lockbox label in planner window's caption. Label should be brief because of limited space
          //% "Trove/Lockbox"
          //@ Planner
          text: qsTrId("id-planner-trove-lockbox")
        }
      }
      Text { color: 'white'; width: 30; horizontalAlignment: Text.AlignHCenter; text: root.model.troves }
      Row {
        spacing: 4
        SvgImage { source: 'qrc:/qt/qml/labcompass/assets/images/lab-content/darkshrine.svg'; anchors.verticalCenter: parent.verticalCenter }
        Text {
          color: Styles.primaryTextColor;
          //: Darkshrine label in planner window's caption. Label should be brief because of limited space
          //% "Darkshrine"
          //@ Planner
          text: qsTrId("id-planner-darkshrine")
        }
      }
      Text { color: 'white'; width: 30; horizontalAlignment: Text.AlignHCenter; text: root.model.darkshrines }
      Row {
        spacing: 4
        SvgImage { source: 'qrc:/qt/qml/labcompass/assets/images/lab-content/silver-door.svg'; anchors.verticalCenter: parent.verticalCenter }
        Text {
          color: Styles.primaryTextColor;
          //: Silver Cache label in planner window's caption. Label should be brief because of limited space
          //% "Silver Cache"
          //@ Planner
          text: qsTrId("id-silver-cache")
        }
      }
      Text { color: Styles.primaryTextColor; width: 30; horizontalAlignment: Text.AlignHCenter; text: root.model.silverCaches }
    }
  }
}
