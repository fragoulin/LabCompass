#include "optionswindow.h"

Q_GLOBAL_STATIC(QStringList, UI_SCALE_FACTORS, {
    "0.5",
    "0.75",
    "1",
    "1.25",
    "1.5",
    "1.75",
    "2",
    "2.5"
})

Q_GLOBAL_STATIC(QStringList, LANGUAGES_CODES, {
    "en",
    "fr",
    "pt",
    "ru",
    "th",
    "es",
    "de",
    "ko",
    "ja"
})

Q_GLOBAL_STATIC(QStringList, LANGUAGES, {
    "English",
    "Français",
    "Português",
    "Русский",
    "ไทย",
    "Español",
    "Deutsch",
    "한국어",
    "日本語"
})

OptionsWindow::OptionsWindow(QQmlEngine* engine, Settings* settings)
    : Window(engine, true, true)
{
    this->settings = settings;

    setSource(QUrl("qrc:/qt/qml/labcompass/options/Options.qml"));

    QStringList uiScaleFactorModel;
    std::transform(UI_SCALE_FACTORS->constBegin(), UI_SCALE_FACTORS->constEnd(), std::back_inserter(uiScaleFactorModel),
        [](const QString& s) { return s + 'x'; });
    rootObject()->findChild<QObject*>("uiScaleFactorInput")->setProperty("model", uiScaleFactorModel);

    QStringList languageModel;
    std::transform(LANGUAGES->constBegin(), LANGUAGES->constEnd(), std::back_inserter(languageModel),
                   [](const QString& s) { return s; });
    rootObject()->findChild<QObject*>("languageInput")->setProperty("model", languageModel);

    connect(global(), SIGNAL(optionsWindowOpenChanged()),
        this, SLOT(onWindowOpenChanged()));
    connect(rootObject(), SIGNAL(openUrl(QString)),
        this, SLOT(onOpenUrl(QString)));
    connect(rootObject(), SIGNAL(browseClientPath()),
        this, SLOT(onBrowseClientPath()));
    connect(rootObject(), SIGNAL(save()),
        this, SLOT(save()));
}

void OptionsWindow::onWindowOpenChanged()
{
    bool open = global()->property("optionsWindowOpen").toBool();

    if (open) {
        load();
    }

    setVisible(open);
}

void OptionsWindow::onBrowseClientPath()
{
    const auto& file = QFileDialog::getOpenFileName(
        this,
        //: File dialog title to find game client
        //% "Find Game Client"
        //@ Options
        qtTrId("id-dialog-find-game-client"),
        "",
        //: File dialog info and extension type
        //% "Path of Exile Client (*.exe)"
        //@ Options
        qtTrId("id-dialog-poe-client")
    );
    if (!file.isEmpty()) {
        rootObject()->setProperty("poeClientPath", QFileInfo(file).dir().absolutePath());
    }
}

void OptionsWindow::onOpenUrl(const QString& url)
{
    global()->setProperty("optionsWindowOpen", false);
    QDesktopServices::openUrl(QUrl(url));
}

void OptionsWindow::load()
{
    foreach (const auto& name, settingNames) {
        const auto& s = name.toLocal8Bit().constData();
        rootObject()->setProperty(s, settings->property(s));
    }

    int uiScaleFactorIndex = UI_SCALE_FACTORS->indexOf(settings->get_scaleFactor());
    if (uiScaleFactorIndex == -1) {
        uiScaleFactorIndex = UI_SCALE_FACTORS->indexOf("1");
    }
    rootObject()->setProperty("uiScaleFactorIndex", uiScaleFactorIndex);

    auto languageCode = settings->get_languageCode();
    int languageIndex = LANGUAGES_CODES->indexOf(languageCode);
    if (languageIndex == -1) {
        languageIndex = LANGUAGES_CODES->indexOf("en");
    }
    rootObject()->setProperty("languageIndex", languageIndex);
}

void OptionsWindow::save()
{
    foreach (const auto& name, settingNames) {
        settings->setProperty(name.toLocal8Bit().constData(), rootObject()->property(name.toLocal8Bit().constData()));
    }

    int uiScaleFactorIndex = rootObject()->property("uiScaleFactorIndex").toInt();
    settings->setProperty("scaleFactor", (*UI_SCALE_FACTORS)[uiScaleFactorIndex]);

    int languageIndex = rootObject()->property("languageIndex").toInt();
    settings->setProperty("languageCode", (*LANGUAGES_CODES)[languageIndex]);

    emit(settingsUpdated(*settings));
}
