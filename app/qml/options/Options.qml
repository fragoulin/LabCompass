import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.VectorImage
import labcompass
import '..'

WindowWithShadow {
  id: root
  signal openUrl(string url)
  signal browseClientPath
  signal save

  property int contentWidth: 600
  Material.theme: Material.Dark

  property alias poeClientPath: clientPathInput.text
  property alias portalSkipsSection: portalSkipsSectionInput.checked
  property alias multiclientSupport: multiclientSupportInput.checked
  property alias showMinimap: showMinimapInput.checked
  property alias uiScaleFactorIndex: uiScaleFactorInput.currentIndex
  property alias languageIndex: languageInput.currentIndex

  property alias toggleHideUiHotkey: toggleHideUiHotkeyEdit.keySequence

  Column {
    id: column
    width: root.contentWidth
    topPadding: 20
    bottomPadding: 20
    spacing: 20

    Row {
      x: 40
      height: 60
      spacing: 30
      Text {
        anchors.verticalCenter: parent.verticalCenter
        text: 'LabCompass'
        color: Global.primaryTextColor
        font.pixelSize: 32
      }
      Column {
        anchors.verticalCenter: parent.verticalCenter
        Text {
          color: Global.primaryTextColor
          text: Global.version
        }
        Row {
          MaterialInk {
            width: 32
            height: 32
            onClicked: root.openUrl('https://github.com/fragoulin/LabCompass')
            VectorImage {
              width: 24
              height: 24
              anchors.centerIn: parent
              source: 'qrc:/qt/qml/labcompass/assets/images/github.svg'
            }
          }
        }
      }
      MaterialInk {
        anchors.verticalCenter: parent.verticalCenter
        width: 150
        height: 30
        visible: Global.model.newVersionAvailable
        onClicked: openUrl('https://github.com/fragoulin/LabCompass/releases/tag/' + Global.model.settings.latestVersion)
        Rectangle {
          anchors.fill: parent
          color: Global.accentColor
          radius: 2
          z: -1
          Text {
            anchors.centerIn: parent
            //: Label indicating that an update for LabCompass is available
            //% "Update Available"
            //@ Options
            text: qsTrId("id-update-available")
            font.preferShaping: false
            color: Global.primaryTextColor
          }
        }
        NotificationIndicator {}
      }

      ComboBox {
        id: languageInput
        objectName: 'languageInput'
        width: 130
        implicitContentWidthPolicy: ComboBox.ContentItemImplicitWidth
      }
    }

    Rectangle {
      width: root.contentWidth
      height: 2
      color: Qt.lighter(Global.primaryColor)
    }

    Text {
      x: 40
      color: Global.primaryTextColor
      //: Title for options window
      //% "Options"
      //@ Options
      text: qsTrId("id-options")
      font.preferShaping: false
      font.pixelSize: 24
    }

    Item {
      width: root.contentWidth
      height: 30
      TextHighlightTab {
        id: tab
        anchors.fill: parent
        anchors.leftMargin: 50
        anchors.rightMargin: 50
        model: [
          //: Menu label for client options
          //% "Client"
          //@ Options
          qsTrId("id-menu-client"),
          //: Menu label for UI options
          //% "UI"
          //@ Options
          qsTrId("id-menu-ui"),
          //: Menu label for Navigation options
          //% "Navigation"
          //@ Options
          qsTrId("id-meby-navigation"),
          //: Menu label for Hotkeys options
          //% "Hotkeys"
          //@ Options
          qsTrId("id-menu-hotkeys")
        ]
      }
    }

    StackLayout {
      currentIndex: tab.currentItem
      anchors {
        left: parent.left
        right: parent.right
        leftMargin: 60
        rightMargin: 60
      }

      OptionsGridLayout {
        id: clientTab
        Text {
          Layout.columnSpan: 2
          color: Global.primaryTextColor
          //: Label for Game Client Path option. Label should be brief because of small space available
          //% "Game Client Path"
          //@ Options
          text: qsTrId("id-game-client-path")
          font.preferShaping: false
        }
        TextField {
          id: clientPathInput
          Layout.fillWidth: true
          font.family: 'Open Sans'
        }
        MaterialInk {
          width: 32
          height: 32
          onClicked: root.browseClientPath();
          Image {
            anchors.centerIn: parent
            width: 24
            height: 24
            source: 'qrc:/qt/qml/labcompass/assets/images/browse.svg'
            sourceSize: Qt.size(96, 96)
          }
        }

        Text {
          color: Global.primaryTextColor
          //: Label for Multi-client Support option. Label should be brief because of small space available
          //% "Multi-client Support (Experimental)"
          //@ Options
          text: qsTrId("id-multi-client-support")
          font.preferShaping: false
          font.pixelSize: 20
        }
        CheckBox {
          id: multiclientSupportInput
          width: 24
          height: 24
        }
      }

      OptionsGridLayout {
        id: uiTab
        Text {
          Layout.fillWidth: true
          color: Global.primaryTextColor
          //: Label for Show Minimap When Available option. Label should be brief because of small space available
          //% "Show Minimap When Available"
          //@ Options
          text: qsTrId("id-show-minimap-when-available")
          font.preferShaping: false
          font.pixelSize: 20
        }
        CheckBox {
          id: showMinimapInput
          width: 24
          height: 24
        }

        Text {
          Layout.fillWidth: true
          color: Global.primaryTextColor
          //: Label for Show UI Scale Factor option. Label should be brief because of small space available
          //% "UI Scale Factor <sup>*</sup>"
          //@ Options
          text: qsTrId("id-ui-scale-factor")
          font.preferShaping: false
          font.pixelSize: 20
        }
        ComboBox {
          id: uiScaleFactorInput
          objectName: 'uiScaleFactorInput'
        }
      }

      OptionsGridLayout {
        id: navigationTab
        Text {
          Layout.fillWidth: true
          color: Global.primaryTextColor
          //: Label related to player taking a portal. This action should skips current section. Label should be brief because of small space available
          //% "Taking Portals Skips Current Section"
          //@ Options
          text: qsTrId("id-taking-portals-skips-current-section")
          font.preferShaping: false
          font.pixelSize: 20
        }
        CheckBox {
          id: portalSkipsSectionInput
          width: 24
          height: 24
        }
      }

      OptionsGridLayout {
        id: shortcutTab
        Text {
          Layout.fillWidth: true
          color: Global.primaryTextColor
          //: Label for Hide/Show Compass option. Label should be brief because of small space available
          //% "Hide/Show Compass"
          //@ Options
          text: qsTrId("id-hide-show-compass")
          font.preferShaping: false
          font.pixelSize: 20
        }
        KeySequenceEdit {
          id: toggleHideUiHotkeyEdit
        }
      }
    }

    Text {
      x: 40
      color: Global.secondaryTextColor
      //: Label for indicating that LabCompass must be restarted to apply changes. Label should be brief because of small space available
      //% "<sup>*</sup> Restart LabCompass to Apply Changes"
      //@ Options
      text: qsTrId("id-restart-labcompass-to-apply-changes")
      font.preferShaping: false
      font.pixelSize: 16
    }
  }

  MaterialInk {
    id: closeButton
    width: 40
    height: 40
    anchors.right: column.right
    anchors.rightMargin: 10
    anchors.top: column.top
    anchors.topMargin: 10
    onClicked: Global.optionsWindowOpen = false;
    VectorImage {
      anchors.centerIn: parent
      source: 'qrc:/qt/qml/labcompass/assets/images/close.svg'
      width: 16
      height: 16
    }
  }

  MaterialInk {
    id: saveButton
    anchors.right: column.right
    anchors.rightMargin: 30
    anchors.bottom: column.bottom
    anchors.bottomMargin: 15
    width: 80
    height: 30
    onClicked: {
      root.save();
      Global.optionsWindowOpen = false;
    }
    Rectangle {
      anchors.fill: parent
      color: Global.accentColor
      radius: 2
      z: -1
      Text {
        anchors.centerIn: parent
        //: Label for OK button in options window
        //% "OK"
        //@ Options
        text: qsTrId("id-options-ok")
        color: Global.primaryTextColor
      }
    }
  }
}
