#include "mainwindow.h"
#include "util/detectdisplay.h"

MainWindow::MainWindow(QQmlEngine* engine)
    : Window(engine, true, true)
{
    setSource(QUrl("qrc:/qt/qml/labcompass/MainWindow.qml"));

    const auto& header = rootObject()->findChild<QObject*>("header");
    connect(header, SIGNAL(drag(int,int)),
        this, SLOT(onDrag(int,int)));
    connect(header, SIGNAL(exit()),
        QCoreApplication::instance(), SLOT(quit()));

    // Qhotkey not compatible with wayland https://github.com/Skycoder42/QHotkey/issues/14
    if (!isWaylandDisplay()) {
        connect(global(), SIGNAL(compassVisibleChanged()),
            this, SLOT(onCompassVisibleChanged()));
    }
}

void MainWindow::onCompassVisibleChanged()
{
    bool visible = global()->property("compassVisible").toBool();
    setVisible(visible);
}

void MainWindow::onDrag(int dx, int dy)
{
    move(x() + dx, y() + dy);
    emit moved(x(), y());
}
