#ifndef APPLICATION_H
#define APPLICATION_H

#include "controller/labyrinthcontroller.h"
#include "controller/navigationcontroller.h"
#include "hotkey/hotkeybinding.h"
#include "model/applicationmodel.h"
#include "worker/datechecker.h"
#include "worker/logwatcher.h"
#include "worker/versionchecker.h"

class Application : public QApplication {
    Q_OBJECT

    ApplicationModel model;
    QQmlApplicationEngine engine;
    QObject* global;
    QWindow* window;
    QWindow* plannerWindow;
    QWindow* roomPresetsWindow;
    QWindow* puzzleWindow;
    QWindow* optionsWindow;
    QTranslator translator;

    std::unique_ptr<QSystemTrayIcon> trayIcon;
    std::unique_ptr<QMenu> trayIconMenu;

    std::unique_ptr<LogWatcher> logWatcher;
    std::unique_ptr<VersionChecker> versionChecker;
    std::unique_ptr<DateChecker> dateChecker;

    std::unique_ptr<LabyrinthController> labyrinthController;
    std::unique_ptr<NavigationController> navigationController;

    std::unique_ptr<HotkeyBinding> toggleHideUiHotkey;

public:
    Application(int& argc, char** argv);

private slots:
    void onAboutToQuit();
    void onImportFileFailed();

private:
    void init();
    void initSettings();
    void initWindowKit();
    void initTranslations();
    void initResources();
    void initSystemTrayIcon();
    void initHelpers();
    void initWindows();
    void initWorkers();
    void initControllers();
    void initHotkeys();

    void restorePreviouslyLoadedMap();
};

#endif // APPLICATION_H
