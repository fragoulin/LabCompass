#include "trayiconmenu.h"

TrayIconMenu::TrayIconMenu()
{
    addResetAction();
    addQuitAction();
}

void TrayIconMenu::addResetAction()
{
    resetAction.reset(new QAction(tr("Reset LabCompass")));
    addAction(resetAction.get());

    connect(resetAction.get(), &QAction::triggered, []() {
        QSettings("FutureCode", "LabCompass").clear();
        qApp->quit();
        QProcess::startDetached(qApp->arguments()[0], qApp->arguments());
    });
}

void TrayIconMenu::addQuitAction()
{
    quitAction.reset(new QAction(tr("Quit")));
    addAction(quitAction.get());

    connect(quitAction.get(), &QAction::triggered,
        []() { QCoreApplication::quit(); });
}
