#include "logwatcher.h"

#ifdef Q_OS_WIN
#include "windows.h"
#include "psapi.h"
#endif

Q_GLOBAL_STATIC(QStringList, START_LINES, {
    "Izaro: Ascend with precision.",
    "Izaro: The Goddess is watching.",
    "Izaro: Justice will prevail.",
})

Q_GLOBAL_STATIC(QStringList, FINISH_LINES, {
    "Izaro: I die for the Empire!",
    "Izaro: Delight in your gilded dungeon, ascendant.",
    "Izaro: Your destination is more dangerous than the journey, ascendant.",
    "Izaro: Triumphant at last!",
    "Izaro: You are free!",
    "Izaro: The trap of tyranny is inescapable.",
})

Q_GLOBAL_STATIC(QStringList, IZARO_BATTLE_START_LINES, {
    "Izaro: Complex machinations converge to a single act of power.",
    "Izaro: Slowness lends strength to one\'s enemies.",
    "Izaro: When one defiles the effigy, one defiles the emperor.",
    "Izaro: The essence of an empire must be shared equally amongst all of its citizens.",
    "Izaro: It is the sovereign who empowers the sceptre. Not the other way round.",
    "Izaro: Some things that slumber should never be awoken.",
    "Izaro: An emperor is only as efficient as those he commands.",
    "Izaro: The emperor beckons and the world attends.",
})

Q_GLOBAL_STATIC(QStringList, SECTION_FINISH_LINES, {
    "Izaro: By the Goddess! What ambition!",
    "Izaro: Such resilience!",
    "Izaro: You are inexhaustible!",
    "Izaro: You were born for this!",
})

Q_GLOBAL_STATIC(QStringList, PORTAL_SPAWN_LINES, {
    ": A portal to Izaro appears."
})

Q_GLOBAL_STATIC(QStringList, ROOM_NAMES, {
    //: Basilica Annex room name. Must match exactly room name displayed in Path of Exile client
    //% "Basilica Annex"
    //@ Labyrinth
    qtTrId("id-basilica-annex"),
    //: Basilica Atrium room name. Must match exactly room name displayed in Path of Exile client
    //% "Basilica Atrium"
    //@ Labyrinth
    qtTrId("id-basilica-atrium"),
    //: Basilica Halls room name. Must match exactly room name displayed in Path of Exile client
    //% "Basilica Halls"
    //@ Labyrinth
    qtTrId("id-basilica-halls"),
    //: Basilica Passage room name. Must match exactly room name displayed in Path of Exile client
    //% "Basilica Passage"
    //@ Labyrinth
    qtTrId("id-basilica-passage"),
    //: Domain Crossing room name. Must match exactly room name displayed in Path of Exile client
    //% "Domain Crossing"
    //@ Labyrinth
    qtTrId("id-domain-crossing"),
    //: Domain Enclosure room name. Must match exactly room name displayed in Path of Exile client
    //% "Domain Enclosure"
    //@ Labyrinth
    qtTrId("id-domain-enclosure"),
    //: Domain Path room name. Must match exactly room name displayed in Path of Exile client
    //% "Domain Path"
    //@ Labyrinth
    qtTrId("id-domain-path"),
    //: Domain Walkways room name. Must match exactly room name displayed in Path of Exile client
    //% "Domain Walkways"
    //@ Labyrinth
    qtTrId("id-domain-walkways"),
    //: Estate Crossing room name. Must match exactly room name displayed in Path of Exile client
    //% "Estate Crossing"
    //@ Labyrinth
    qtTrId("id-estate-crossing"),
    //: Estate Enclosure room name. Must match exactly room name displayed in Path of Exile client
    //% "Estate Enclosure"
    //@ Labyrinth
    qtTrId("id-estate-enclosure"),
    //: Estate Path room name. Must match exactly room name displayed in Path of Exile client
    //% "Estate Path"
    //@ Labyrinth
    qtTrId("id-estate-path"),
    //: Estate Walkways room name. Must match exactly room name displayed in Path of Exile client
    //% "Estate Walkways"
    //@ Labyrinth
    qtTrId("id-estate-walkways"),
    //: Mansion Annex room name. Must match exactly room name displayed in Path of Exile client
    //% "Mansion Annex"
    //@ Labyrinth
    qtTrId("id-mansion-annex"),
    //: Mansion Atrium room name. Must match exactly room name displayed in Path of Exile client
    //% "Mansion Atrium"
    //@ Labyrinth
    qtTrId("id-mansion-atrium"),
    //: Mansion Halls room name. Must match exactly room name displayed in Path of Exile client
    //% "Mansion Halls"
    //@ Labyrinth
    qtTrId("id-mansion-halls"),
    //: Mansion Passage room name. Must match exactly room name displayed in Path of Exile client
    //% "Mansion Passage"
    //@ Labyrinth
    qtTrId("id-mansion-passage"),
    //: Sanitorium Annex room name. Must match exactly room name displayed in Path of Exile client
    //% "Sanitorium Annex"
    //@ Labyrinth
    qtTrId("id-sanitorium-annex"),
    //: Sanitorium Halls room name. Must match exactly room name displayed in Path of Exile client
    //% "Sanitorium Halls"
    //@ Labyrinth
    qtTrId("id-sanitorium-halls"),
    //: Sanitorium Passage room name. Must match exactly room name displayed in Path of Exile client
    //% "Sanitorium Passage"
    //@ Labyrinth
    qtTrId("id-sanitorium-passage"),
    //: Sepulchre Annex room name. Must match exactly room name displayed in Path of Exile client
    //% "Sepulchre Annex"
    //@ Labyrinth
    qtTrId("id-sepulchre-annex"),
    //: Sepulchre Atrium room name. Must match exactly room name displayed in Path of Exile client
    //% "Sepulchre Atrium"
    //@ Labyrinth
    qtTrId("id-sepulchre-atrium"),
    //: Sepulchre Halls room name. Must match exactly room name displayed in Path of Exile client
    //% "Sepulchre Halls"
    //@ Labyrinth
    qtTrId("id-sepulchre-halls"),
    //: Sepulchre Passage room name. Must match exactly room name displayed in Path of Exile client
    //% "Sepulchre Passage"
    //@ Labyrinth
    qtTrId("id-sepulchre-passage"),
})

Q_GLOBAL_STATIC(QRegularExpression, LOG_REGEX, "^\\d+/\\d+/\\d+ \\d+:\\d+:\\d+.*?\\[.*?(\\d+)\\] : (?:<<set:\\w+>>)*(.*)$")

LogWatcher::LogWatcher(ApplicationModel* model)
{
    this->model = model;
    clientPath = model->get_settings()->get_poeClientPath();
    file.reset(new QFile(QDir(clientPath).filePath("logs/Client.txt")));

    timer.setInterval(1000);
    timer.setSingleShot(false);
    timer.start();
    connect(&timer, &QTimer::timeout,
        this, &LogWatcher::work);
}

void LogWatcher::work()
{
    // reset file if client path settings have changed
    auto newClientPath = model->get_settings()->get_poeClientPath();
    if (clientPath != newClientPath) {
        clientPath = newClientPath;
        file.reset(new QFile(QDir(clientPath).filePath("logs/Client.txt")));
    }

    // attempt to open file
    if (!file->isOpen()) {
        if (!file->open(QIODevice::ReadOnly)) {

            // try to detect client
            clientPath = findGameClientPath();
            if (clientPath.isEmpty()) {
                model->update_logFileOpen(false);
                return;
            }
            file.reset(new QFile(QDir(clientPath).filePath("logs/Client.txt")));
            if (!file->open(QIODevice::ReadOnly)) {
                model->update_logFileOpen(false);
                return;
            }
            model->get_settings()->set_poeClientPath(clientPath);
        }
        model->update_logFileOpen(true);
        file->seek(file->size());
    }

    while (true) {
        auto line = file->readLine();
        if (line.isEmpty()) {
            break;
        }
        parseLine(QString::fromUtf8(line).trimmed());
    }
}

void LogWatcher::parseLine(const QString line)
{
    auto logMatch = LOG_REGEX->match(line);
    if (logMatch.hasMatch()) {
        auto clientId = logMatch.captured(1);

        auto logContent = logMatch.captured(2).trimmed();
        QRegularExpression roomChangeRegex;
        //: Regular expression used to match room entered by player character in Path of Exile client log file (.*?) Matches and captures the room name.
        //% "^You have entered (.*?)\\.$"
        //@ Labyrinth
        roomChangeRegex.setPattern(qtTrId("id-labyrinth-regex-you-have-entered"));
        auto roomChangeMatch = roomChangeRegex.match(logContent);

        if (START_LINES->contains(logContent)) {
            setActiveClient(clientId);
            emit labStarted();

        } else if (roomChangeMatch.hasMatch()) {
            auto roomName = roomChangeMatch.captured(1);
            qInfo() << "    roomName" << roomName;
            //: Room name: Aspirants' Plaza. Must match exactly room name displayed in Path of Exile client
            //% "Aspirants' Plaza"
            //@ Labyrinth
            auto aspirantsPlaza = qtTrId("id-labyrinth-aspirants-plaza");
            qInfo() << "    Aspirant plaza translated" << aspirantsPlaza;

            if (roomName == aspirantsPlaza) {
                qInfo() << "    Emit plaza entered";
                setActiveClient(clientId);
                emit plazaEntered();

            } else if (isValidRoomName(roomName)) {
                qInfo() << "    Room valid";
                if (isLogFromValidClient(clientId)) {
                    qInfo() << "    Emit room changed";
                    emit roomChanged(roomName);
                }

            } else {
                qInfo() << "    Unknown room";
                if (isLogFromValidClient(clientId)) {
                    qInfo() << "    Emit lab exit";
                    emit labExit();
                }
            }

        } else if (FINISH_LINES->contains(logContent)) {
            if (isLogFromValidClient(clientId)) {
                emit sectionFinished();
                emit labFinished();
            }

        } else if (IZARO_BATTLE_START_LINES->contains(logContent)) {
            if (isLogFromValidClient(clientId)) {
                emit izaroBattleStarted();
            }

        } else if (SECTION_FINISH_LINES->contains(logContent)) {
            if (isLogFromValidClient(clientId)) {
                emit sectionFinished();
            }

        } else if (PORTAL_SPAWN_LINES->contains(logContent)) {
            if (isLogFromValidClient(clientId)) {
                emit portalSpawned();
            }
        }
    }
}

QString LogWatcher::findGameClientPath()
{
#ifdef Q_OS_WIN
    auto hwnd = FindWindowA("POEWindowClass", nullptr);
    if (!hwnd) {
        return QString();
    }

    DWORD pid;
    GetWindowThreadProcessId(hwnd, &pid);

    auto handle = OpenProcess(PROCESS_QUERY_LIMITED_INFORMATION, FALSE, pid);
    if (!handle)
        return QString();

    char buf[1024];
    auto r = GetModuleFileNameExA(handle, NULL, buf, 1024);
    QString path = r ? QFileInfo(QString(buf)).dir().absolutePath() : QString();

    CloseHandle(handle);
    return path;
#else
    return QString();
#endif
}

void LogWatcher::setActiveClient(const QString& clientId)
{
    activeClientId = clientId;
}

bool LogWatcher::isLogFromValidClient(const QString& clientId) const
{
    return !model->get_settings()->get_multiclientSupport() || clientId == activeClientId;
}

bool LogWatcher::isValidRoomName(const QString& roomName)
{
    return ROOM_NAMES->contains(roomName);
}
