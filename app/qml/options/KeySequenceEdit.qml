import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import labcompass

Button {
  id: root

  Layout.minimumWidth: 200

  property alias modifierlessAllowed: helper.modifierlessAllowed
  property alias multiKeyShortcutsAllowed: helper.multiKeyShortcutsAllowed
  property alias keySequence: helper.keySequence

  KeySequenceHelper {
    id: helper
    multiKeyShortcutsAllowed: false
    modifierlessAllowed: true
    onCaptureFinished: focus = false;
  }

  checkable: true
  focus: checked
  text: helper.shortcutDisplay

  onClicked: {
    if (!checked) {
      helper.cancelRecording();
    }
  }

  onCheckedChanged: {
    if (checked) {
      forceActiveFocus();
      helper.captureKeySequence();
    }
  }

  onFocusChanged: {
    if (!focus) {
      checked = false;
    }
  }

  Keys.onPressed: (event) => {
    helper.keyPressed(event.key, event.modifiers);
    event.accepted = true;
  }
  Keys.onReleased: (event) => {
    helper.keyReleased(event.key, event.modifiers);
    event.accepted = true;
  }
}
