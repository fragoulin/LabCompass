#include "mainwindow.h"
#include "util/detectdisplay.h"

MainWindow::MainWindow(QQmlEngine* engine)
    : Window(engine, true, true)
{
    setSource(QUrl("qrc:/qt/qml/labcompass/MainWindow.qml"));

    compass = rootObject()->findChild<QQuickItem*>("compass");
    toolbar = rootObject()->findChild<QQuickItem*>("toolbar");
    directionHud = rootObject()->findChild<QQuickItem*>("directionHud");
    const int adjustedSize = 118; // TODO hardcoded value
    const int compassRegionX = 2; // TODO hardcoded value
    const int compassRegionY = (directionHud->height() - adjustedSize ) / 2;
    compassRegion = QRegion(compassRegionX, compassRegionY, adjustedSize, adjustedSize, QRegion::Ellipse);

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
/*
void MainWindow::mousePressEvent(QMouseEvent *event)
{
    // Check if event position is inside compass region in order to exclude toolbar for drag&drop
    if (!compassRegion.contains(event->pos())) {
        dragPosition = QPoint();
//        event->ignore();
    } else if (event->button() == Qt::LeftButton) {
        dragPosition = event->globalPosition().toPoint() - frameGeometry().topLeft();
//        event->accept();
    }
}

void MainWindow::mouseMoveEvent(QMouseEvent *event)
{
    if (!dragPosition.isNull() && (event->buttons() & Qt::LeftButton)) {
        move(event->globalPosition().toPoint() - dragPosition);
        emit moved(x(), y());
//        event->accept();
//    } else {
//        event->ignore();
    }
}

void MainWindow::mouseReleaseEvent(QMouseEvent *event )
{
}
*/
void MainWindow::resizeEvent(QResizeEvent * /* event */ )
{
    const int toolbarRegionX = directionHud->width() - toolbar->width();
    const int toolbarRegionY = toolbar->y();
    QRegion toolbarRegion(toolbarRegionX, toolbarRegionY, toolbar->width(), toolbar->height());
    QRegion mask = compassRegion.united(toolbarRegion);
//    setMask(mask);
}
