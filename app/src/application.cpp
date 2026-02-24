#include "application.h"
#include "global.h" // IWYU pragma: export
#include "helper/roompresethelper.h"
#include "keysequence/keysequencehelper.h"
#include "tray/trayiconmenu.h"
#include "version.h"

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
    model.get_settings()->save();
}

void Application::init()
{
    qInfo() << "Initialization started";

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

void Application::initTranslations()
{
    auto locale = QLocale::system();
    auto filename = QApplication::applicationName();
    auto directory = ":/translations";

    if (translator.load(locale, filename, "_", directory))
        installTranslator(&translator);
    else
        qWarning() << "Failed to load translation file" << filename << "from directory" << directory << "and locale" << locale;
}

void Application::initResources()
{
    QQuickStyle::setStyle("Material");

    qmlRegisterType<KeySequenceHelper>("labcompass", 1, 0, "KeySequenceHelper");
    engine.load(QUrl("qrc:/qt/qml/labcompass/GlobalAccessor.qml"));
    global = engine.rootObjects()[0]->property("o").value<QObject*>();
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
        trayIcon->setToolTip(tr("LabCompass"));
        trayIcon->show();
    }
}

void Application::initHelpers()
{
    RoomPresetHelper::instance = new RoomPresetHelper();
}

void Application::initWindows()
{
    mainWindow.reset(new MainWindow(&engine));
    connect(mainWindow.get(), &MainWindow::moved,
        [this](int x, int y) { model.get_settings()->set_mainWindowPosition(QPoint(x, y)); });

    auto mainWindowPosition = model.get_settings()->get_mainWindowPosition();
    auto screenGeometry = mainWindow->quickWindow()->screen()->geometry();
    if (!screenGeometry.contains(mainWindowPosition))
        mainWindowPosition = screenGeometry.center();
    mainWindow->move(mainWindowPosition);

    mainWindow->show();

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
    connect(toggleHideUiHotkey.get(), &HotkeyBinding::activated,
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
