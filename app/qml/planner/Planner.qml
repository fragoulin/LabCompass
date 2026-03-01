import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.VectorImage
import labcompass
import '..'

WindowWithShadow {
  id: window
  property var labyrinthModel: Global.model.labyrinthModel

  signal drag(int dx, int dy)
  signal importLabNotesButtonClicked
  signal importLabNotesFromUrl(url url)
  signal openUrl(string url)

  Column {
    id: grid
    spacing: 20
    topPadding: 20
    bottomPadding: 20
    width: 1210

    Item {
      height: 50
      width: grid.width

      Grid {
        columns: 5
        leftPadding: 20
        spacing: 20
        anchors.verticalCenter: parent.verticalCenter
        verticalItemAlignment: Grid.AlignVCenter

        DragMoveArea {
          width: 350
          height: 80
          onDrag: (dx, dy) => window.drag(dx, dy)

          Text {
            //: Labyrinth Planner window title
            //% "Labyrinth Planner"
            //@ Planner
            text: qsTrId("id-labyrinth-planner")
            anchors.centerIn: parent
            color: Global.primaryTextColor
            font.pixelSize: 32
          }
        }

        Item {
          width: 400
          height: 30
          Text {
            anchors.centerIn: parent
            //: Layout: room title
            //% "Layout: %1"
            //@ Planner
            text: labyrinthModel.title ? qsTrId("id-layout-room-title").arg(labyrinthModel.title) :
                                         //: Label displayed in the planner when no map is loaded
                                         //% "No lab notes loaded"
                                         //@ Planner
                                         qsTrId("id-planner-no-map-loaded")
            color: Global.primaryTextColor
          }
        }

        MaterialInk {
          width: 120
          height: 30
          onClicked: openUrl('https://www.poelab.com')
          Text {
            anchors.centerIn: parent
            //: Get Maps button label to access poelab website. Label should be brief because of limited space available
            //% "Get Maps"
            //@ Planner
            text: qsTrId("id-get-maps")
            color: Global.primaryTextColor
          }
          NotificationIndicator {
            visible: !Global.loadedMapUpToDate
          }
        }

        MaterialInk {
          width: 120
          height: 30
          onClicked: importLabNotesButtonClicked()
          Rectangle {
            anchors.fill: parent
            color: Global.accentColor
            radius: 2
            z: -1
            Text {
              anchors.centerIn: parent
              //: Import Maps button label to open file dialog. Label should be brief because of limited space available
              //% "Import Maps"
              //@ Planner
              text: qsTrId("id-import-maps")
              color: Global.primaryTextColor
            }
          }
        }
      }

      MaterialInk {
        id: closeButton
        width: 40
        height: 40
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.top: parent.top
        onClicked: Global.plannerWindowOpen = false;
        VectorImage {
          anchors.centerIn: parent
          source: 'qrc:/qt/qml/labcompass/assets/images/close.svg'
          width: 16
          height: 16
        }
      }
    }

    Rectangle {
      width: grid.width
      height: 2
      color: Qt.lighter(Global.primaryColor)
    }

    Grid {
      columns: 2
      columnSpacing: 20
      rowSpacing: 10

      leftPadding: 40
      rightPadding: 40

      LabyrinthMapDisplay {
        id: labyrinthMapDisplay
        objectName: 'labyrinthMapDisplay'
        width: 830
        height: 260
        z: 1
        roomModel: Global.model.roomModel
        connectionModel: Global.model.connectionModel
        goldenDoorModel: Global.model.goldenDoorModel
      }

      PlanSummaryDisplay {
        id: planSummaryDisplay
        width: 280
        height: 260
        color: Global.primaryColor
        model: Global.model.planSummaryModel
      }

      PlannedRouteDisplay {
        id: plannedRouteDisplay
        width: 830
        height: 28
        plannedRouteModel: Global.model.plannedRouteModel
      }

      Item {
        width: 280
        height: 28

        Row {
          spacing: 4
          anchors.verticalCenter: parent.verticalCenter
          anchors.right: parent.right

          Text {
            //: Donate button label displayed before Paypal and Patreon buttons. Label should be brief because of limited space available
            //% "Donate: "
            //@ Planner
            text: qsTrId("id-planner-donate")
            color: Global.primaryTextColor
            font.pixelSize: 20
          }
          MaterialInk {
            width: 24
            height: 24
            onClicked: openUrl('https://www.paypal.me/futurecode')
            VectorImage {
              source: 'qrc:/qt/qml/labcompass/assets/images/paypal.svg'
              anchors.fill: parent
              width: 16
              height: 16
            }
          }
          MaterialInk {
            width: 24
            height: 24
            onClicked: openUrl('https://www.patreon.com/futurecode')
            VectorImage {
              source: 'qrc:/qt/qml/labcompass/assets/images/patreon.svg'
              anchors.fill: parent
              width: 16
              height: 16
            }
          }
        }
      }
    }
  }

  MapDropArea {
    anchors.fill: parent
    onDropUrl: importLabNotesFromUrl(url)
  }
}
