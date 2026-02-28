import QtQuick

MouseArea {
  id: root

  signal drag(int dx, int dy)

  property bool dragging: false
  property point clickPos

  cursorShape: dragging ? Qt.ClosedHandCursor : Qt.OpenHandCursor
  onPressed: (mouse) => {
    dragging = true;
    clickPos = Qt.point(mouse.x, mouse.y);
  }
  onReleased: {
    dragging = false;
  }
  onPositionChanged: (mouse) => {
    root.drag(mouse.x - clickPos.x, mouse.y - clickPos.y);
  }
}
