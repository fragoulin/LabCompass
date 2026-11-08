#include "setupdebugoutput.h"
#include <QDir>
#include <QFile>
#include <QHash>
#include <QStandardPaths>
#include <QString>
#include <QTextStream>
#include <QTime>
#include <QtDebug>
#include <QtGlobal>
using namespace Qt::StringLiterals;

Q_GLOBAL_STATIC(QString, logFilePath, "")
static bool logToFile = false;

void customMessageOutput(QtMsgType type, const QMessageLogContext& context, const QString& msg)
{
    QHash<QtMsgType, QString> msgLevelHash({ { QtDebugMsg, u"Debug"_s }, { QtInfoMsg, u"Info"_s }, { QtWarningMsg, u"Warning"_s }, { QtCriticalMsg, u"Critical"_s }, { QtFatalMsg, u"Fatal"_s } });
    QByteArray localMsg = msg.toLocal8Bit();
    QTime time = QTime::currentTime();
    QString formattedTime = time.toString(u"hh:mm:ss.zzz"_s);
    QByteArray formattedTimeMsg = formattedTime.toLocal8Bit();
    QString logLevelName = msgLevelHash[type];
    QByteArray logLevelMsg = logLevelName.toLocal8Bit();

    if (logToFile) {
        QString txt = u"%1 %2: %3"_s.arg(formattedTime, logLevelName, msg);
        QFile outFile(*logFilePath);
        if (!outFile.open(QIODevice::WriteOnly | QIODevice::Append)) {
            fprintf(stderr, "%s %s: %s (%s:%u)\n", formattedTimeMsg.constData(), logLevelMsg.constData(), localMsg.constData(), context.file, context.line);
            fflush(stderr);
        } else {
            QTextStream ts(&outFile);
            ts << txt << Qt::endl;
            outFile.close();
        }
    } else {
        fprintf(stderr, "%s %s: %s (%s:%u)\n", formattedTimeMsg.constData(), logLevelMsg.constData(), localMsg.constData(), context.file, context.line);
        fflush(stderr);
    }

    if (type == QtFatalMsg) {
        abort();
    }
}

void setupDebugOutput()
{
#ifdef FORCE_DEBUG_REDIRECT
    logToFile = true;
#else
    QByteArray envVar = qgetenv("QTDIR"); //  check if the app is running in Qt Creator
    logToFile = envVar.isEmpty();
#endif

    if (logToFile) {
        QDir dir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
        dir.mkpath(".");
        *logFilePath = dir.absoluteFilePath(u"log.txt"_s);
        qInfo() << "Log file path:" << *logFilePath;
        QFile outFile(*logFilePath);
        if (!outFile.open(QIODevice::WriteOnly)) {
            qWarning() << "Failed to open log file with write access:" << *logFilePath;
        } else
            outFile.close();
    }

    qInstallMessageHandler(customMessageOutput);
}
