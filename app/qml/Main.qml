import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import labcompass
import "compass"
import "instruction"
import QWindowKit

Window {
  id: window
  objectName: "MainWindow"
  title: "LabCompass"
  minimumWidth: 230
  minimumHeight: 270
  maximumWidth: minimumWidth
  maximumHeight: minimumHeight
  color: "transparent"
  visible: Global.compassVisible
  flags: Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint | Qt.WA_TranslucentBackground

  Component.onCompleted: {
    windowAgent.setup(window)
    windowAgent.setTitleBar(titleBar)
    windowAgent.setHitTestVisible(plannerButton, true);
    windowAgent.setHitTestVisible(puzzleButton, true);
    windowAgent.setHitTestVisible(optionsButton, true);
    windowAgent.setSystemButton(WindowAgent.Close, closeButton)
    setWindowPosition()
    Global.compassVisible = true
  }

  WindowAgent {
    id: windowAgent
  }

  ColumnLayout {
      anchors.fill: parent
      spacing: 0

      Rectangle {
          id: titleBar
          Layout.fillWidth: true
          implicitHeight: 42
          color: Global.lightPrimaryColor

          RowLayout {
              anchors.fill: parent
              spacing: 0

              Text {
                  text: window.title
                  color: Global.primaryTextColor
                  elide: Text.ElideRight
                  verticalAlignment: Text.AlignVCenter
                  Layout.leftMargin: 12
                  Layout.fillWidth: true
              }

              ToolbarButton {
                id: plannerButton
                buttonHeight: 24
                source: 'qrc:/qt/qml/labcompass/assets/images/navigation-light.svg'
                active: Global.plannerWindowOpen
                onClicked: {
                  const open = Global.plannerWindowOpen;
                  window.closeAllWindows();
                  if (!open)
                    Global.plannerWindowOpen = true;
                }
                NotificationIndicator {
                  visible: !Global.loadedMapUpToDate
                }
              }

              ToolbarButton {
                id: puzzleButton
                buttonHeight: 24
                source: 'qrc:/qt/qml/labcompass/assets/images/puzzle-light.svg'
                active: Global.puzzleWindowOpen
                onClicked: {
                  const open = Global.puzzleWindowOpen;
                  window.closeAllWindows();
                  if (!open)
                    Global.puzzleWindowOpen = true;
                }
              }

              ToolbarButton {
                id: optionsButton
                buttonHeight: 24
                source: 'qrc:/qt/qml/labcompass/assets/images/settings-light.svg'
                active: Global.optionsWindowOpen
                onClicked: {
                  const open = Global.optionsWindowOpen;
                  window.closeAllWindows();
                  if (!open)
                    Global.optionsWindowOpen = true;
                }

                NotificationIndicator {
                  visible: Global.model.newVersionAvailable
                }
              }

              ToolbarButton {
                id: closeButton
                source: 'qrc:/qt/qml/labcompass/assets/images/close.svg'
                onClicked: Qt.quit()
                buttonHeight: 24
              }
          }
      }

      Rectangle {
          Layout.fillWidth: true
          Layout.fillHeight: true

          color: "transparent"

          Column {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Compass {
              id: compass
            }

            InstructionList {
              id: instructionList
              anchors.right: parent.right
            }
          }
      }
  }

  function setWindowPosition() {
    const mainWindowPosition = Global.model.settings.mainWindowPosition
    if (mainWindowPosition.x < window.screen.width & mainWindowPosition.y < window.screen.height) {
      window.x = mainWindowPosition.x
      window.y = mainWindowPosition.y
    } else {
      windowAgent.centralize()
    }
  }

  function closeAllWindows() {
    Global.plannerWindowOpen = false;
    Global.puzzleWindowOpen = false;
    Global.optionsWindowOpen = false;
    Global.roomPresetsWindowOpen = false;
  }
}
