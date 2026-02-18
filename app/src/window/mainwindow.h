#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include "window/window.h"

class MainWindow : public Window {
    Q_OBJECT

signals:
    void moved(int x, int y);

public:
    MainWindow(QQmlEngine* engine);

private slots:
    void onDrag(int dx, int dy);
    void onCompassVisibleChanged();
};

#endif // MAINWINDOW_H
