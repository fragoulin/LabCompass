#include "mainwindow.h"
#include "util/detectdisplay.h"

MainWindow::MainWindow(QQmlEngine* engine)
    : Window(engine, true, true)
{
    setSource(QUrl("qrc:/qt/qml/labcompass/MainWindow.qml"));

    compass = rootObject()->findChild<QQuickItem*>("compass");

    //: Exit application label on contextual menu
    //% "E&xit"
    //@ Application
    QAction *quitAction = new QAction(qtTrId("id_application_exit"), this);
    connect(quitAction, &QAction::triggered, qApp, &QCoreApplication::quit);
    addAction(quitAction);

    setContextMenuPolicy(Qt::ActionsContextMenu);

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

void MainWindow::mousePressEvent(QMouseEvent *event)
{
    // TODO check if event position is inside compass (to exclude toolbar for drag&drop)
    if (event->button() == Qt::LeftButton) {
        dragPosition = event->globalPosition().toPoint() - frameGeometry().topLeft();
        event->accept();
    }
}

void MainWindow::mouseMoveEvent(QMouseEvent *event)
{
    if (event->buttons() & Qt::LeftButton) {
        move(event->globalPosition().toPoint() - dragPosition);
        emit moved(x(), y());
        event->accept();
    }
}

void MainWindow::resizeEvent(QResizeEvent * /* event */)
{
    qInfo() << "geometry" << this->geometry();
    qInfo() << "x" << compass->x();
    qInfo() << "y" << compass->y();
    qInfo() << "width" << compass->width();
    qInfo() << "height" << compass->height();
    int adjustedSize = 118; // TODO
    qInfo() << "adjusted size" << adjustedSize;
    QRegion compassRegion(compass->x(), compass->y(), adjustedSize, adjustedSize, QRegion::Ellipse);
    setMask(compassRegion);
}
