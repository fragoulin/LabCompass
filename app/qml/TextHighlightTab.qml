pragma ComponentBehavior: Bound

import QtQuick

HighlightTab {
  id: root

  property list<string> model: []

  items: model.length ? model.length : 1
  onItemClicked: index => currentItem = index

  activeLayerComponent: Row {
    Repeater {
      model: root.model
      TabLabel {
        required property string modelData
        width: root.width / root.items
        height: root.height
        active: true
        text: modelData
      }
    }
  }

  inactiveLayerComponent: Row {
    Repeater {
      model: root.model
      TabLabel {
        required property string modelData
        width: root.width / root.items
        height: root.height
        active: false
        text: modelData
      }
    }
  }
}
