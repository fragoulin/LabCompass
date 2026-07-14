import QtQuick

Image {
  width: String(source) ? 16 : 0
  height: String(source) ? 16 : 0
  sourceSize: String(source) ? Qt.size(width * 4, height * 4) : Qt.size(0, 0)
  mipmap: true
  asynchronous: true
}
