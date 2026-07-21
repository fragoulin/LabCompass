#include "application.h"
#include "global.h" // IWYU pragma: export
#include "helper/roompresethelper.h"
#include "keysequence/keysequencehelper.h"
#include "tray/trayiconmenu.h"
#include "version.h"
#include <QWKQuick/qwkquickglobal.h>

Application::Application(int& argc, char** argv)
    : QApplication(argc, argv)
{
    connect(this, &Application::aboutToQuit,
        this, &Application::onAboutToQuit);

    init();
    restorePreviouslyLoadedMap();
}

void Application::onAboutToQuit()
{
    model.get_settings()->set_mainWindowPosition(QPoint(window->x(), window->y()));
    model.get_settings()->save();
}

void Application::init()
{
    qInfo() << "Initialization started";

    qInfo() << "Init Window Kit";
    initWindowKit();

    qInfo() << "Init translations";
    initTranslations();

    qInfo() << "Init resources";
    initResources();

    qInfo() << "Init system tray icon";
    initSystemTrayIcon();

    qInfo() << "Init helpers";
    initHelpers();

    qInfo() << "Init workers";
    initWorkers();

    qInfo() << "Init windows";
    initWindows();

    qInfo() << "Init controllers";
    initControllers();

    qInfo() << "Init hotkeys";
    initHotkeys();

    qInfo() << "Initialization finished";
}

void Application::initWindowKit()
{
    qputenv("QT_QUICK_CONTROLS_STYLE", "Basic");
    QQuickWindow::setDefaultAlphaBuffer(true);
    QWK::registerTypes(&engine);
}

void Application::initTranslations()
{
    auto locale = QLocale::system();
    qInfo() << "Default locale" << locale;
    auto filename = QApplication::applicationName();
    auto directory = ":/translations";

//    if (translator.load(locale, filename, "_", directory))
//        installTranslator(&translator);
//    else {
//        qWarning() << "Failed to load translation file" << filename << "from directory" << directory << "and locale" << locale << ".Fallback to english language";
    auto fallbackFilename = filename + "_en";
    if(translator.load(fallbackFilename, directory)) {
        qInfo() << "Using english as fallback language";
        installTranslator(&translator);
    }
    else
        qWarning() << "Failed to load fallback english file" << fallbackFilename << "from directory" << directory;
//    }
}

void Application::initResources()
{
    QQuickStyle::setStyle("Material");

    qmlRegisterType<KeySequenceHelper>("labcompass", 1, 0, "KeySequenceHelper");
    engine.load(QUrl("qrc:/qt/qml/labcompass/GlobalAccessor.qml"));
    auto rootObjects = engine.rootObjects();
    global = rootObjects[0]->property("o").value<QObject*>();
    global->setProperty("model", QVariant::fromValue<QObject*>(&model));
    global->setProperty("version", VERSION);
#ifdef QT_DEBUG
    global->setProperty("debug", true);
#endif

    if (-1 == QFontDatabase::addApplicationFont(":/assets/fonts/Fontin-SmallCaps.ttf"))
        qWarning() << "Failed to load font Fontin-SmallCaps.ttf";
    if (-1 == QFontDatabase::addApplicationFont(":/assets/fonts/OpenSans-Regular.ttf"))
        qWarning() << "Failed to load font OpenSans-Regular.ttf";

    QFont font("Fontin SmallCaps");
    font.setPixelSize(16);
    setFont(font);
}

void Application::initSystemTrayIcon()
{
    if (QSystemTrayIcon::isSystemTrayAvailable()) {
        trayIcon.reset(new QSystemTrayIcon(QIcon(":/assets/icons/LabCompass.ico")));
        trayIconMenu.reset(new TrayIconMenu());
        trayIcon->setContextMenu(trayIconMenu.get());
        //: Tooltip for tray icon
        //% "LabCompass"
        //@ TrayIcon
        trayIcon->setToolTip(qtTrId("id-trayicon-labcompass"));
        trayIcon->show();
    }
}

void Application::initHelpers()
{
    RoomPresetHelper::instance = new RoomPresetHelper();
}

void Application::initWindows()
{
    connect(&engine, &QQmlApplicationEngine::objectCreated, this, [this](QObject *object) {
        window = (QWindow*) object;
        auto mainWindowPosition = model.get_settings()->get_mainWindowPosition();
        auto screenGeometry = window->screen()->geometry();
        if (!screenGeometry.contains(mainWindowPosition))
            mainWindowPosition = screenGeometry.center();
        window->setPosition(mainWindowPosition);
    });
    engine.load(QUrl(QStringLiteral("qrc:/qt/qml/labcompass/MainWindow.qml")));

    plannerWindow.reset(new PlannerWindow(&engine));

    puzzleWindow.reset(new PuzzleWindow(&engine));

    optionsWindow.reset(new OptionsWindow(&engine, model.get_settings()));

    roomPresetsWindow.reset(new RoomPresetsWindow(&engine));
}

void Application::initWorkers()
{
    logWatcher.reset(new LogWatcher(&model));

    engine.rootContext()->setContextProperty("logWatcher", logWatcher.get());

    versionChecker.reset(new VersionChecker(&model));
    dateChecker.reset(new DateChecker(&model));
}

void Application::initControllers()
{
    labyrinthController.reset(new LabyrinthController(&model));
    connect(plannerWindow.get(), &PlannerWindow::importFile,
        labyrinthController.get(), &LabyrinthController::importFile);
    connect(roomPresetsWindow.get(), &RoomPresetsWindow::setRoomPreset,
        labyrinthController.get(), &LabyrinthController::onRoomPresetSet);

    navigationController.reset(new NavigationController(&model));
    connect(logWatcher.get(), &LogWatcher::plazaEntered,
        navigationController.get(), &NavigationController::onPlazaEntered);
    connect(logWatcher.get(), &LogWatcher::labStarted,
        navigationController.get(), &NavigationController::onLabStarted);
    connect(logWatcher.get(), &LogWatcher::sectionFinished,
        navigationController.get(), &NavigationController::onSectionFinished);
    connect(logWatcher.get(), &LogWatcher::labExit,
        navigationController.get(), &NavigationController::onLabExit);
    connect(logWatcher.get(), &LogWatcher::roomChanged,
        navigationController.get(), &NavigationController::onRoomChanged);
    connect(logWatcher.get(), &LogWatcher::portalSpawned,
        navigationController.get(), &NavigationController::onPortalSpawned);

    connect(plannerWindow.get(), &PlannerWindow::setRoomIsTarget,
        navigationController.get(), &NavigationController::onRoomIsTargetSet);
    connect(plannerWindow.get(), &PlannerWindow::setCurrentRoom,
        navigationController.get(), &NavigationController::onRoomIdSet);
}

void Application::initHotkeys()
{
    toggleHideUiHotkey.reset(new HotkeyBinding(global, model.get_settings(), "toggleHideUiHotkey", SIGNAL(toggleHideUiHotkeyChanged(QString))));
    connect(toggleHideUiHotkey.get(), &HotkeyBinding::activated, this,
        [this]() {
            bool visible = global->property("compassVisible").toBool();
            global->setProperty("compassVisible", !visible);
        });
}

void Application::restorePreviouslyLoadedMap()
{
    const auto& currentDate = model.get_currentUtcDate();
    const auto& lastLoadedMapDate = model.get_settings()->get_lastLoadedMapDate();

    if (currentDate == lastLoadedMapDate) {
        qInfo() << "Loading previously loaded map from cache";

        const auto& appData = QDir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
        const auto& lastLoadedMap = appData.absoluteFilePath("lastLoaded.map");
        labyrinthController->importFile(lastLoadedMap);
    }
}
