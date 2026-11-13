pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QWindowKit
import QtQuick.Dialogs
import common

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

  WindowAgent {
    id: windowAgent
  }

  property int contentWidth: 600
  Material.theme: Material.Dark

  property alias toggleHideUiHotkey: toggleHideUiHotkeyEdit.keySequence

  required property Settings settings
  required property string version

  Component.onCompleted: {
    windowAgent.setup(root)
  }

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
          id: titlebar
          anchors.verticalCenter: parent.verticalCenter
          text: 'LabCompass'
          color: Styles.primaryTextColor
          font.pixelSize: 32
          Component.onCompleted: windowAgent.setTitleBar(titlebar)
        }
        Column {
          anchors.verticalCenter: parent.verticalCenter
          Text {
            color: Styles.primaryTextColor
            text: root.version
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
          onClicked: Qt.openUrlExternally('https://github.com/fragoulin/LabCompass/releases/tag/' + root.settings.latestVersion)
          Rectangle {
            anchors.fill: parent
            color: Styles.accentColor
            radius: 2
            z: -1
            Text {
              anchors.centerIn: parent
              //: Label indicating that an update for LabCompass is available
              //% "Update Available"
              //@ Options
              text: qsTrId("id-update-available")
              font.preferShaping: false
              color: Styles.primaryTextColor
            }
          }
          NotificationIndicator {}
        }

        ListModel {
          id: languages
          ListElement {
            code: 'en'
            text: 'English'
            image: 'qrc:/qt/qml/labcompass/assets/images/flags/gb.svg'
          }
          ListElement {
            code: 'pt'
            text: 'Português'
            image: 'qrc:/qt/qml/labcompass/assets/images/flags/br.svg'
          }
          ListElement {
            code: 'ru'
            text: 'Русский'
            image: 'qrc:/qt/qml/labcompass/assets/images/flags/ru.svg'
          }
          ListElement {
            code: 'th'
            text: 'ไทย'
            image: 'qrc:/qt/qml/labcompass/assets/images/flags/th.svg'
          }
          ListElement {
            code: 'de'
            text: 'Deutsch'
            image: 'qrc:/qt/qml/labcompass/assets/images/flags/de.svg'
          }
          ListElement {
            code: 'fr';
            text: 'Français'
            image: 'qrc:/qt/qml/labcompass/assets/images/flags/fr.svg'
          }
          ListElement {
            code: 'es'
            text: 'Español'
            image: 'qrc:/qt/qml/labcompass/assets/images/flags/es.svg'
          }
          ListElement {
            code: 'ja'
            text: '日本語'
            image: 'qrc:/qt/qml/labcompass/assets/images/flags/jp.svg'
          }
          ListElement {
            code: 'ko'
            text: '한국어'
            image: 'qrc:/qt/qml/labcompass/assets/images/flags/kr.svg'
          }
        }

        ComboBox {
          id: languageInput
          objectName: 'languageInput'
          width: 150
          implicitContentWidthPolicy: ComboBox.ContentItemImplicitWidth
          model: languages
          textRole: "text"
          valueRole: "code"
          currentValue: root.settings.languageCode ?? 'en'
          // Add flags next to language name in popup
          delegate: ItemDelegate {
              id: delegate

              required property var model
              required property int index

              width: languageInput.width
              contentItem: Row {
                spacing: 10
                SvgImage {
                  source: delegate.model['image']
                  anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                  text: delegate.model[languageInput.textRole]
                  color: Styles.primaryTextColor
                  font: languageInput.font
                  elide: Text.ElideRight
                  verticalAlignment: Text.AlignVCenter
                  anchors.verticalCenter: parent.verticalCenter
                }
              }
              highlighted: languageInput.highlightedIndex === index
          }
          contentItem: Row {
            spacing: 10
            leftPadding: 10
            SvgImage {
              source: (languageInput.model as ListModel).get(languageInput.currentIndex)['image']
              anchors.verticalCenter: parent.verticalCenter
            }
            Text {
              leftPadding: 0
              rightPadding: languageInput.indicator.width + languageInput.spacing
              color: Styles.primaryTextColor
              text: languageInput.displayText
              font: languageInput.font
              verticalAlignment: Text.AlignVCenter
              anchors.verticalCenter: parent.verticalCenter
              elide: Text.ElideRight
            }
          }
        }
      }

      Rectangle {
        width: root.contentWidth
        height: 2
        color: Qt.lighter(Styles.primaryColor)
      }

      Text {
        x: 40
        color: Styles.primaryTextColor
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
            color: Styles.primaryTextColor
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
            text: root.settings.poeClientPath
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
            color: Styles.primaryTextColor
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
            checked: root.settings.multiclientSupport
          }
        }

        OptionsGridLayout {
          id: uiTab
          Text {
            Layout.fillWidth: true
            color: Styles.primaryTextColor
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
            checked: root.settings.showMinimap
          }

          Text {
            Layout.fillWidth: true
            color: Styles.primaryTextColor
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
                value: 0.5
                //: Label for UI Scale Factor 0.5
                //% "0.5x"
                //@ Options
                text: qsTrId("id-ui-scale-factor-0.5")
              }
              ListElement {
                value: 0.75
                //: Label for UI Scale Factor 0.75
                //% "0.75x"
                //@ Options
                text: qsTrId("id-ui-scale-factor-0.75")
              }
              ListElement {
                value: 1
                //: Label for UI Scale Factor 1
                //% "1x"
                //@ Options
                text: qsTrId("id-ui-scale-factor-1")
              }
              ListElement {
                value: 1.25
                //: Label for UI Scale Factor 1.25
                //% "1.25x"
                //@ Options
                text: qsTrId("id-ui-scale-factor-1.25")
              }
              ListElement {
                value: 1.5
                //: Label for UI Scale Factor 1.5
                //% "1.5x"
                //@ Options
                text: qsTrId("id-ui-scale-factor-1.5")
              }
              ListElement {
                value: 1.75
                //: Label for UI Scale Factor 1.75
                //% "1.75x"
                //@ Options
                text: qsTrId("id-ui-scale-factor-1.75")
              }
              ListElement {
                value: 2
                //: Label for UI Scale Factor 2
                //% "2x"
                //@ Options
                text: qsTrId("id-ui-scale-factor-2")
              }
              ListElement {
                value: 2.5
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
            currentValue: root.settings.scaleFactor ?? 1
          }
        }

        OptionsGridLayout {
          id: navigationTab
          Text {
            Layout.fillWidth: true
            color: Styles.primaryTextColor
            //: Label related to player taking a portal.
            //: This action should skips current section.
            //: Label should be brief because of small space available
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
            checked: root.settings.portalSkipsSection
          }
        }

        OptionsGridLayout {
          id: shortcutTab
          Text {
            Layout.fillWidth: true
            color: Styles.primaryTextColor
            //: Label for Hide/Show Compass option.
            //: Label should be brief because of small space available
            //% "Hide/Show Compass"
            //@ Options
            text: qsTrId("id-hide-show-compass")
            font.preferShaping: false
            font.pixelSize: 20
          }
          KeySequenceEdit {
            id: toggleHideUiHotkeyEdit
            keySequence: root.settings.toggleHideUiHotkey
          }
        }
      }

      Text {
        x: 40
        color: Styles.secondaryTextColor
        //: Label for indicating that LabCompass must be restarted to apply changes.
        //: Label should be brief because of small space available
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
        color: Styles.accentColor
        radius: 2
        z: -1
        Text {
          anchors.centerIn: parent
          //: Label for OK button in options window
          //% "OK"
          //@ Options
          text: qsTrId("id-options-ok")
          color: Styles.primaryTextColor
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
      onAccepted: clientPathInput.text = selectedFile
  }

  function saveSettings() {
    settings.poeClientPath = clientPathInput.text
    settings.portalSkipsSection = portalSkipsSectionInput.checked
    settings.multiclientSupport = multiclientSupportInput.checked
    settings.showMinimap = showMinimapInput.checked
    settings.toggleHideUiHotkey = toggleHideUiHotkeyEdit.keySequence
    settings.scaleFactor = uiScaleFactorInput.currentValue
    settings.languageCode = languageInput.currentValue

    root.settingsUpdated()
  }

  onClosing: () => {
    Global.optionsWindowOpen = false
  }
}
