#include "settings.h"
#include "version.h"

using namespace Qt::StringLiterals;

QVariantMap defaultSettings {
    { u"mainWindowPosition"_s, QPoint(-1, -1) },
    { u"poeClientPath"_s, "" },
    { u"latestVersion"_s, "" },
    { u"lastVersionCheckAttempt"_s, 0LL },
    { u"lastVersionCheckSuccess"_s, 0LL },
    { u"lastLoadedMapDate"_s, QDate() },
    { u"importDirectory"_s, "" },

    { u"multiclientSupport"_s, false },

    { u"portalSkipsSection"_s, true },

    { u"scaleFactor"_s, "1" },
    { u"showMinimap"_s, true },

    { u"toggleHideUiHotkey"_s, "" },

    { u"languageCode"_s, "en" },
};

Settings::Settings(QObject* parent)
    : QObject(parent)
{
    settings.reset(new QSettings());

    m_multiclientSupport = false;
    m_portalSkipsSection = true;
    m_showMinimap = true;
}

void Settings::load()
{
    for (auto i = defaultSettings.constBegin(); i != defaultSettings.constEnd(); i++) {
        auto propertyName = i.key();
        auto propertyValue = settings->value(i.key(), i.value());
        setProperty(propertyName.toLocal8Bit().constData(), propertyValue);
    }

    if (settings->value(u"version"_s).toString() != VERSION) {
        settings->setValue(u"version"_s, VERSION);
        set_latestVersion("");
        set_lastVersionCheckAttempt(0LL);
        set_lastVersionCheckSuccess(0LL);
    }

    qInfo().noquote() << "Settings loaded" << QJsonDocument::fromVariant(toVariant()).toJson(QJsonDocument::Compact);
}

void Settings::save()
{
    for (auto i = defaultSettings.constBegin(); i != defaultSettings.constEnd(); i++) {
        const auto& propertyName = i.key();
        const auto& propertyValue = property(i.key().toLocal8Bit().constData());
        settings->setValue(propertyName, propertyValue);
    }

    qInfo().noquote() << "Settings saved" << QJsonDocument::fromVariant(toVariant()).toJson(QJsonDocument::Compact);
}

QVariant Settings::toVariant() const
{
    QVariantMap result;
    auto allKeys = settings->allKeys();
    for (const auto& propertyName : std::as_const(allKeys)) {
        auto value = settings->value(propertyName);

        switch (value.typeId()) {
        case QMetaType::QPoint:
            value = QVariantMap { { u"x"_s, value.toPoint().x() }, { u"y"_s, value.toPoint().y() } };
            break;
        case QMetaType::QDate:
            value = value.toDate().toString(u"yyyy-MM-dd"_s);
            break;
        default:;
        }

        result[propertyName] = value;
    }
    return result;
}
