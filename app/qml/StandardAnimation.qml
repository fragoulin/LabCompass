import QtQuick

NumberAnimation {
  easing.type: Easing.Bezier
  easing.bezierCurve: [0.4, 0.0, 0.2, 1.0, 1.0, 1.0]
  duration: 100
}
