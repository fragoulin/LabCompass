#ifndef LOGWATCHER_H
#define LOGWATCHER_H

#include "model/applicationmodel.h"
#include <QtQmlIntegration/qqmlintegration.h>

class LogWatcher : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_UNCREATABLE("")

    ApplicationModel* model;
    QTimer timer;
    QString clientPath;
    QString activeClientId;
    std::unique_ptr<QFile> file;

signals:
    void plazaEntered();
    void labStarted();
    void labFinished();
    void izaroBattleStarted();
    void sectionFinished();
    void labExit();
    void roomChanged(QString name);
    void portalSpawned();

public:
    LogWatcher(ApplicationModel* model);

private slots:
    void work();

private:
    void parseLine(const QString line);
    QString findGameClientPath();
    void setActiveClient(const QString& clientId);
    bool isLogFromValidClient(const QString& clientId) const;
    bool isValidRoomName(const QString& roomName);
};

#endif // LOGWATCHER_H
