import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import labcompass
import '..'
import QWindowKit
import QtQuick.Dialogs

Window {
  id: root
  objectName: "OptionsWindow"
  minimumWidth: column.width + 20
  minimumHeight: column.height + 20
  maximumWidth: minimumWidth
  maximumHeight: minimumHeight

  visible: Global.optionsWindowOpen
  color: "transparent"

  signal settingsUpdated()

  Component.onCompleted: {
    windowAgent.setup(root)
  }

  WindowAgent {
    id: windowAgent
  }

  property int contentWidth: 600
  Material.theme: Material.Dark

  property alias poeClientPath: clientPathInput.text
  property alias portalSkipsSection: portalSkipsSectionInput.checked
  property alias multiclientSupport: multiclientSupportInput.checked
  property alias showMinimap: showMinimapInput.checked
  property alias uiScaleFactorIndex: uiScaleFactorInput.currentIndex
  property alias languageIndex: languageInput.currentIndex
  property alias toggleHideUiHotkey: toggleHideUiHotkeyEdit.keySequence

  property var settings: Global.model.settings

  WindowWithShadow {
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
              onClicked: () => {
                Qt.openUrlExternally('https://github.com/fragoulin/LabCompass/releases/latest')
                Global.optionsWindowOpen = false
              }
              SvgImage {
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
          onClicked: Qt.openUrlExternally('https://github.com/fragoulin/LabCompass/releases/tag/' + Global.model.settings.latestVersion)
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

        ListModel {
          id: languages
          ListElement {
            code: 'en';
            text: 'English'
          }
          ListElement {
            code: 'fr';
            text: 'Français'
          }
          ListElement {
            code: 'pt';
            text: 'Português'
          }
          ListElement {
            code: 'ru';
            text: 'Русский'
          }
          ListElement {
            code: 'th';
            text: 'ไทย'
          }
          ListElement {
            code: 'es';
            text: 'Español'
          }
          ListElement {
            code: 'de';
            text: 'Deutsch'
          }
          ListElement {
            code: 'ko';
            text: '한국어'
          }
          ListElement {
            code: 'ja';
            text: '日本語'
          }
        }

        ComboBox {
          id: languageInput
          objectName: 'languageInput'
          width: 130
          implicitContentWidthPolicy: ComboBox.ContentItemImplicitWidth
          model: languages
          textRole: "text"
          valueRole: "code"
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
            implicitWidth: 32
            implicitHeight: 32
            onClicked: fileDialog.open();
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
            implicitWidth: 24
            implicitHeight: 24
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
            implicitWidth: 24
            implicitHeight: 24
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

          ListModel {
              id: scaleFactors
              ListElement {
                value: 0.5;
                //: Label for UI Scale Factor 0.5
                //% "0.5x"
                //@ Options
                text: qsTrId("id-ui-scale-factor-0.5")
              }
              ListElement {
                value: 0.75;
                //: Label for UI Scale Factor 0.75
                //% "0.75x"
                //@ Options
                text: qsTrId("id-ui-scale-factor-0.75")
              }
              ListElement {
                value: 1;
                //: Label for UI Scale Factor 1
                //% "1x"
                //@ Options
                text: qsTrId("id-ui-scale-factor-1")
              }
              ListElement {
                value: 1.25;
                //: Label for UI Scale Factor 1.25
                //% "1.25x"
                //@ Options
                text: qsTrId("id-ui-scale-factor-1.25")
              }
              ListElement {
                value: 1.5;
                //: Label for UI Scale Factor 1.5
                //% "1.5x"
                //@ Options
                text: qsTrId("id-ui-scale-factor-1.5")
              }
              ListElement {
                value: 1.75;
                //: Label for UI Scale Factor 1.75
                //% "1.75x"
                //@ Options
                text: qsTrId("id-ui-scale-factor-1.75")
              }
              ListElement {
                value: 2;
                //: Label for UI Scale Factor 2
                //% "2x"
                //@ Options
                text: qsTrId("id-ui-scale-factor-2")
              }
              ListElement {
                value: 2.5;
                //: Label for UI Scale Factor 2.5
                //% "2.5x"
                //@ Options
                text: qsTrId("id-ui-scale-factor-2.5")
              }
          }

          ComboBox {
            id: uiScaleFactorInput
            objectName: 'uiScaleFactorInput'
            model: scaleFactors
            textRole: "text"
            valueRole: "value"
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
            implicitWidth: 24
            implicitHeight: 24
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
      SvgImage {
        anchors.centerIn: parent
        source: 'qrc:/qt/qml/labcompass/assets/images/close.svg'
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
        root.saveSettings();
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

  FileDialog {
      id: fileDialog
      //: File dialog title to find game client
      //% "Find Game Client"
      //@ Options
      title: qsTrId("id-dialog-find-game-client")
      //: File dialog info and extension type
      //% "Path of Exile Client (*.exe)"
      //@ Options
      nameFilters: qsTrId("id-dialog-poe-client")
      onAccepted: root.poeClientPath = selectedFile
  }

  function saveSettings() {
    getSettingsNames().forEach(name => {
      settings[name] = root[name]
    })

    settings['scaleFactor'] = uiScaleFactorInput.currentValue
    settings['languageCode'] = languageInput.currentValue
    root.settingsUpdated()
  }

  function loadSettings() {
    getSettingsNames().forEach(name => {
      root[name] = settings[name]
    })

    const scaleFactor = settings['scaleFactor'] ?? 1
    root.uiScaleFactorIndex = uiScaleFactorInput.indexOfValue(scaleFactor)

    const languageCode = settings['languageCode'] ?? 'en';
    root.languageIndex = languageInput.indexOfValue(languageCode);
  }

  function getSettingsNames() {
    return [
      "poeClientPath",
      "portalSkipsSection",
      "multiclientSupport",
      "showMinimap",
      "toggleHideUiHotkey",
    ];
  }

  Connections {
    target: Global
    function onOptionsWindowOpenChanged() {
      const open = Global.optionsWindowOpen
      if (open) {
        root.loadSettings()
      }
    }
  }
}
