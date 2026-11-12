#ifndef HOTKEYBINDING_H
#define HOTKEYBINDING_H

#include <QHotkey>
#include <QtQmlIntegration/qqmlintegration.h>

class HotkeyBinding : public QHotkey {
    Q_OBJECT
    QML_ELEMENT
    QML_UNCREATABLE("")

    QObject* global;
    QObject* settings;
    QString propertyName;

public:
    HotkeyBinding(QObject* globalObject, QObject* hotKeySettings, QByteArray hotKeypropertyName, QByteArray propertyChangeSignal);

private slots:
    void rebindHotkey();
    void onOptionsWindowOpenChanged();
};

#endif // HOTKEYBINDING_H
