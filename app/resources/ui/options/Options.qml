import QtQuick 2.8
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.1
import QtQuick.Layouts 1.3
import com.labcompass 1.0
import '..'

WindowWithShadow {
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

  property alias toggleHideUiHotkey: toggleHideUiHotkeyEdit.keySequence

  Column {
    id: column
    width: contentWidth
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
            onClicked: openUrl('https://github.com/fragoulin/LabCompass')
            SvgImage {
              width: 24
              height: 24
              anchors.centerIn: parent
              source: 'qrc:/images/github.svg'
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
            text: qsTr('Update Available')
            font.preferShaping: false
            color: Global.primaryTextColor
          }
        }
        NotificationIndicator {}
      }
    }

    Rectangle {
      width: contentWidth
      height: 2
      color: Qt.lighter(Global.primaryColor)
    }

    Text {
      x: 40
      color: Global.primaryTextColor
      text: qsTr('Options')
      font.preferShaping: false
      font.pixelSize: 24
    }

    Item {
      width: contentWidth
      height: 30
      TextHighlightTab {
        id: tab
        anchors.fill: parent
        anchors.leftMargin: 50
        anchors.rightMargin: 50
        model: [qsTr('Client'), qsTr('UI'), qsTr('Navigation'), qsTr('Hotkeys')]
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
          text: qsTr('Game Client Path')
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
          onClicked: browseClientPath();
          Image {
            anchors.centerIn: parent
            width: 24
            height: 24
            source: 'qrc:/images/browse.svg'
            sourceSize: Qt.size(96, 96)
          }
        }

        Text {
          color: Global.primaryTextColor
          text: qsTr('Multi-client Support (Experimental)')
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
          text: qsTr('Show Minimap When Available')
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
          text: qsTr('UI Scale Factor <sup>*</sup>')
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
          text: qsTr('Taking Portals Skips Current Section')
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
          text: qsTr('Hide/Show Compass')
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
      text: qsTr('<sup>*</sup> Restart LabCompass to Apply Changes')
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
      source: 'qrc:/images/close.svg'
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
      save();
      Global.optionsWindowOpen = false;
    }
    Rectangle {
      anchors.fill: parent
      color: Global.accentColor
      radius: 2
      z: -1
      Text {
        anchors.centerIn: parent
        text: qsTr('OK')
        color: Global.primaryTextColor
      }
    }
  }
}
