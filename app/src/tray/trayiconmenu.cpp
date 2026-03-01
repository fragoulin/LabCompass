#include "trayiconmenu.h"

TrayIconMenu::TrayIconMenu()
{
    addResetAction();
    addQuitAction();
}

void TrayIconMenu::addResetAction()
{
    //: Label for reset action in tray icon
    //% "Reset LabCompass"
    //@ TrayIcon
    resetAction.reset(new QAction(qtTrId("id-trayicon-reset")));
    addAction(resetAction.get());

    connect(resetAction.get(), &QAction::triggered, []() {
        QSettings("FutureCode", "LabCompass").clear();
        qApp->quit();
        QProcess::startDetached(qApp->arguments()[0], qApp->arguments());
    });
}

void TrayIconMenu::addQuitAction()
{
    //: Label for quit action in tray icon
    //% "Quit"
    //@ TrayIcon
    quitAction.reset(new QAction(qtTrId("id-trayicon-quit")));
    addAction(quitAction.get());

    connect(quitAction.get(), &QAction::triggered,
        []() { QCoreApplication::quit(); });
}
