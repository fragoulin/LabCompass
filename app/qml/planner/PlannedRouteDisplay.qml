import QtQuick
import labcompass
import '..'

Item {
  id: root

  property var plannedRouteModel

  Row {
    width: parent.width
    spacing: 4
    clip: true
    anchors.verticalCenter: parent.verticalCenter
    Text {
      anchors.verticalCenter: parent.verticalCenter
      //: Label displayed before tha planned route
      //% "Plan: "
      //@ Planner
      text: qsTrId("id-planner-plan")
      color: Global.primaryTextColor
      font.pixelSize: 20
    }
    Repeater {
      id: planView
      model: root.plannedRouteModel
      Rectangle {
        width: 28
        height: 28
        color: Global.primaryColor
        Text {
          anchors.centerIn: parent
          text: model.id
          color: Global.primaryTextColor
          font.pixelSize: 16
        }
      }
    }
  }
}
