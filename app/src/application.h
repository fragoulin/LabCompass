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
    struct Window {
        QUrl url;
        void (Application::*connectionsHandler)(QWindow*);
    };
    using Windows = QMap<QString, Window>;
    void handleMainWindowConnections(QWindow* window);
    void handlePlannerWindowConnections(QWindow* window);
    void handleRoomPresetsWindowConnections(QWindow* window);
    void handlePuzzleWindowConnections(QWindow* window);
    void handleOptionsWindowConnections(QWindow* window);

signals:
    void mainWindowCreated(QWindow* window);

private slots:
    void onAboutToQuit(QPoint windowPosition);
    void onSettingsUpdated();
    void onImportFileFailed();
    void onWindowCreated(QString windowName, QWindow* window);

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
    void createWindow(QString windowName, QUrl windowUrl);
    void restorePreviouslyLoadedMap();
    void updateLanguage(QString languageCode);
};

#endif // APPLICATION_H
