import QtCore
import QtQuick
import labcompass
import ".."
import QWindowKit
import QtQuick.Dialogs

Window {
    id: window
    objectName: "PlannerWindow"
    minimumWidth: grid.width + 20
    minimumHeight: grid.height + 20
    maximumWidth: minimumWidth
    maximumHeight: minimumHeight

    property var labyrinthModel: Global.model.labyrinthModel

    signal importFile(string url)
    signal setRoomIsTarget(string id, bool target)
    signal setCurrentRoom(string id)

    visible: Global.plannerWindowOpen
    color: "transparent"

    //: Labyrinth difficulty: normal
    //% "Normal"
    //@ Labyrinth
    readonly property string labyrinthDifficultyNormal: qsTrId("id-labyrinth-difficulty-normal")

    //: Labyrinth difficulty: cruel
    //% "Cruel"
    //@ Labyrinth
    readonly property string labyrinthDifficultyCruel: qsTrId("id-labyrinth-difficulty-cruel")

    //: Labyrinth difficulty: merciless
    //% "Merciless"
    //@ Labyrinth
    readonly property string labyrinthDifficultyMerciless: qsTrId("id-labyrinth-difficulty-merciless")

    //: Labyrinth difficulty: eternal
    //% "Eternal"
    //@ Labyrinth
    readonly property string labyrinthDifficultyEternal: qsTrId("id-labyrinth-difficulty-uber")

    Component.onCompleted: {
        windowAgent.setup(window);
        windowAgent.setTitleBar(titlebar);
    }

    WindowAgent {
        id: windowAgent
    }

    WindowWithShadow {
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

                    Rectangle {
                        id: titlebar
                        width: 350
                        height: 80
                        color: "transparent"

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
                            //: Layout: room title.
                            //: First parameter is date (formatted using current locale)
                            //: Second parameter is difficulty (Normal, Cruel, Merciless or Uber)
                            //% "Layout: %1 %2"
                            //@ Planner
                            text: window.labyrinthModel.date ? qsTrId("id-layout-room-title").arg(window.labyrinthModel.date.toLocaleDateString(Qt.locale(), Locale.ShortFormat)).arg(window.getLabyrinthDifficulty(window.labyrinthModel.difficulty)) :
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
                        onClicked: Qt.openUrlExternally('https://www.poelab.com')
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
                        onClicked: fileDialog.open()
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
                    width: 40
                    height: 40
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                    anchors.top: parent.top
                    onClicked: Global.plannerWindowOpen = false
                    SvgImage {
                        anchors.centerIn: parent
                        source: 'qrc:/qt/qml/labcompass/assets/images/close.svg'
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
                    onSetCurrentRoom: id => window.setCurrentRoom(id)
                    onSetRoomIsTarget: (id, target) => window.setRoomIsTarget(id, target)
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
                            onClicked: Qt.openUrlExternally('https://www.paypal.me/futurecode')
                            SvgImage {
                                source: 'qrc:/qt/qml/labcompass/assets/images/paypal.svg'
                                anchors.fill: parent
                            }
                        }
                        MaterialInk {
                            width: 24
                            height: 24
                            onClicked: Qt.openUrlExternally('https://www.patreon.com/futurecode')
                            SvgImage {
                                source: 'qrc:/qt/qml/labcompass/assets/images/patreon.svg'
                                anchors.fill: parent
                            }
                        }
                    }
                }
            }
        }

        MapDropArea {
            anchors.fill: parent
            onDropUrl: url => window.importFile(url)
        }
    }

    FileDialog {
        id: fileDialog
        currentFolder: Global.model.settings.importDirectory ? ("file://" + Global.model.settings.importDirectory) : StandardPaths.standardLocations(StandardPaths.DownloadLocation)[0]
        //: File dialog title to import lab notes
        //% "Import Lab Notes"
        //@ Planner
        title: qsTrId("id-dialog-import-lab-notes")
        //: File dialog info and authorized file extensions
        //% "Lab Maps (*.json *.map)"
        //@ Planner
        nameFilters: qsTrId("id-dialog-import-info")
        onAccepted: window.importFile(selectedFile)
    }

    function getLabyrinthDifficulty(difficulty: string): string {
        switch (difficulty) {
        case "Normal":
            return window.labyrinthDifficultyNormal;
        case "Cruel":
            return window.labyrinthDifficultyCruel;
        case "Merciless":
            return window.labyrinthDifficultyMerciless;
        case "Uber":
            return window.labyrinthDifficultyEternal;
        }
        return "";
    }
}
