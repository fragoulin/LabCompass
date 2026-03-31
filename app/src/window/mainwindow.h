#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include "window/window.h"

class MainWindow : public Window {
    Q_OBJECT

signals:
    void moved(int x, int y);

public:
    MainWindow(QQmlEngine* engine);

protected:
    void mouseMoveEvent(QMouseEvent *event) override;
    void mousePressEvent(QMouseEvent *event) override;
    void resizeEvent(QResizeEvent *event) override;

private:
    QPoint dragPosition;
    QQuickItem* compass;
    QQuickItem* toolbar;

private slots:
    void onCompassVisibleChanged();
};

#endif // MAINWINDOW_H
