#ifndef SETTINGS_H
#define SETTINGS_H

#include <QtQmlIntegration/qqmlintegration.h>

class Settings : public QObject {
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QPoint mainWindowPosition READ mainWindowPosition WRITE setMainWindowPosition NOTIFY mainWindowPositionChanged)
    Q_PROPERTY(QString poeClientPath READ poeClientPath WRITE setPoeClientPath NOTIFY poeClientPathChanged)
    Q_PROPERTY(QString latestVersion READ latestVersion WRITE setLatestVersion NOTIFY latestVersionChanged)
    Q_PROPERTY(qint64 lastVersionCheckAttempt READ lastVersionCheckAttempt WRITE setLastVersionCheckAttempt NOTIFY lastVersionCheckAttemptChanged)
    Q_PROPERTY(qint64 lastVersionCheckSuccess READ lastVersionCheckSuccess WRITE setLastVersionCheckSuccess NOTIFY lastVersionCheckSuccessChanged)
    Q_PROPERTY(QDate lastLoadedMapDate READ lastLoadedMapDate WRITE setLastLoadedMapDate NOTIFY lastLoadedMapDateChanged)
    Q_PROPERTY(QString importDirectory READ importDirectory WRITE setImportDirectory NOTIFY importDirectoryChanged)
    Q_PROPERTY(bool multiclientSupport READ multiclientSupport WRITE setMulticlientSupport NOTIFY multiclientSupportChanged)
    Q_PROPERTY(bool portalSkipsSection READ portalSkipsSection WRITE setPortalSkipsSection NOTIFY portalSkipsSectionChanged)
    Q_PROPERTY(QString scaleFactor READ scaleFactor WRITE setScaleFactor NOTIFY scaleFactorChanged)
    Q_PROPERTY(bool showMinimap READ showMinimap WRITE setShowMinimap NOTIFY showMinimapChanged)
    Q_PROPERTY(QString toggleHideUiHotkey READ toggleHideUiHotkey WRITE setToggleHideUiHotkey NOTIFY toggleHideUiHotkeyChanged)
    Q_PROPERTY(QString languageCode READ languageCode WRITE setLanguageCode NOTIFY languageCodeChanged)

    std::unique_ptr<QSettings> settings;

public:
    Settings(QObject* parent = nullptr);
    void load();
    void save();

    void setMainWindowPosition(QPoint mainWindowPosition)
    {
        if (m_mainWindowPosition != mainWindowPosition) {
            m_mainWindowPosition = mainWindowPosition;
            emit mainWindowPositionChanged(mainWindowPosition);
        }
    }
    QPoint mainWindowPosition() const { return m_mainWindowPosition; }

    void setPoeClientPath(QString poeClientPath)
    {
        if (m_poeClientPath != poeClientPath) {
            m_poeClientPath = poeClientPath;
            emit poeClientPathChanged(poeClientPath);
        }
    }
    QString poeClientPath() const { return m_poeClientPath; }

    void setLatestVersion(QString latestVersion)
    {
        if (m_latestVersion != latestVersion) {
            m_latestVersion = latestVersion;
            emit latestVersionChanged(latestVersion);
        }
    }
    QString latestVersion() const { return m_latestVersion; }

    void setLastVersionCheckAttempt(qint64 lastVersionCheckAttempt)
    {
        if (m_lastVersionCheckAttempt != lastVersionCheckAttempt) {
            m_lastVersionCheckAttempt = lastVersionCheckAttempt;
            emit lastVersionCheckAttemptChanged(lastVersionCheckAttempt);
        }
    }
    qint64 lastVersionCheckAttempt() const { return m_lastVersionCheckAttempt; }

    void setLastVersionCheckSuccess(qint64 lastVersionCheckSuccess)
    {
        if (m_lastVersionCheckSuccess != lastVersionCheckSuccess) {
            m_lastVersionCheckSuccess = lastVersionCheckSuccess;
            emit lastVersionCheckSuccessChanged(lastVersionCheckSuccess);
        }
    }
    qint64 lastVersionCheckSuccess() const { return m_lastVersionCheckSuccess; }

    void setLastLoadedMapDate(QDate lastLoadedMapDate)
    {
        if (m_lastLoadedMapDate != lastLoadedMapDate) {
            m_lastLoadedMapDate = lastLoadedMapDate;
            emit lastLoadedMapDateChanged(lastLoadedMapDate);
        }
    }
    QDate lastLoadedMapDate() const { return m_lastLoadedMapDate; }

    void setImportDirectory(QString importDirectory)
    {
        if (m_importDirectory != importDirectory) {
            m_importDirectory = importDirectory;
            emit importDirectoryChanged(importDirectory);
        }
    }
    QString importDirectory() const { return m_importDirectory; }

    void setMulticlientSupport(bool multiclientSupport)
    {
        if (m_multiclientSupport != multiclientSupport) {
            m_multiclientSupport = multiclientSupport;
            emit multiclientSupportChanged(multiclientSupport);
        }
    }
    bool multiclientSupport() const { return m_multiclientSupport; }

    void setPortalSkipsSection(bool portalSkipsSection)
    {
        if (m_portalSkipsSection != portalSkipsSection) {
            m_portalSkipsSection = portalSkipsSection;
            emit portalSkipsSectionChanged(portalSkipsSection);
        }
    }
    bool portalSkipsSection() const { return m_portalSkipsSection; }

    void setScaleFactor(QString scaleFactor)
    {
        if (m_scaleFactor != scaleFactor) {
            m_scaleFactor = scaleFactor;
            emit scaleFactorChanged(scaleFactor);
        }
    }
    QString scaleFactor() const { return m_scaleFactor; }

    void setShowMinimap(bool showMinimap)
    {
        if (m_showMinimap != showMinimap) {
            m_showMinimap = showMinimap;
            emit showMinimapChanged(showMinimap);
        }
    }
    bool showMinimap() const { return m_showMinimap; }

    void setToggleHideUiHotkey(QString toggleHideUiHotkey)
    {
        if (m_toggleHideUiHotkey != toggleHideUiHotkey) {
            m_toggleHideUiHotkey = toggleHideUiHotkey;
            emit toggleHideUiHotkeyChanged(toggleHideUiHotkey);
        }
    }
    QString toggleHideUiHotkey() const { return m_toggleHideUiHotkey; }

    void setLanguageCode(QString languageCode)
    {
        if (m_languageCode != languageCode) {
            m_languageCode = languageCode;
            emit languageCodeChanged(languageCode);
        }
    }
    QString languageCode() const { return m_languageCode; }

signals:
    void mainWindowPositionChanged(const QPoint mainWindowPosition);
    void poeClientPathChanged(const QString poeClientPath);
    void latestVersionChanged(const QString latestVersion);
    void lastVersionCheckAttemptChanged(const qint64 lastVersionCheckAttempt);
    void lastVersionCheckSuccessChanged(const qint64 lastVersionCheckSuccess);
    void lastLoadedMapDateChanged(const QDate lastLoadedMapDate);
    void importDirectoryChanged(const QString importDirectory);
    void multiclientSupportChanged(const bool multiclientSupport);
    void portalSkipsSectionChanged(const bool portalSkipsSection);
    void scaleFactorChanged(const QString scaleFactor);
    void showMinimapChanged(const bool showMinimap);
    void toggleHideUiHotkeyChanged(const QString toggleHideUiHotkey);
    void languageCodeChanged(const QString languageCode);

private:
    QPoint m_mainWindowPosition;
    QString m_poeClientPath;
    QString m_latestVersion;
    qint64 m_lastVersionCheckAttempt;
    qint64 m_lastVersionCheckSuccess;
    QDate m_lastLoadedMapDate;
    QString m_importDirectory;
    bool m_multiclientSupport;
    bool m_portalSkipsSection;
    QString m_scaleFactor;
    bool m_showMinimap;
    QString m_toggleHideUiHotkey;
    QString m_languageCode;
    QVariant toVariant() const;
};

#endif // SETTINGS_H
