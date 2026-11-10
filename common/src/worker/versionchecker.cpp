#include "versionchecker.h"
#include "version.h"

using namespace Qt::StringLiterals;

VersionChecker::VersionChecker(ApplicationModel* applicationModel, QObject* parent)
    : QObject(parent)
{
    this->model = applicationModel;

    nam.get(QNetworkRequest(QUrl(u"https://api.github.com/"_s)));

    timer.setInterval(1000);
    timer.setSingleShot(false);
    timer.start();
    connect(&timer, &QTimer::timeout,
        this, &VersionChecker::work);
}

void VersionChecker::work()
{
    auto latestVersion = model->get_settings()->latestVersion();
    model->update_newVersionAvailable(!latestVersion.isEmpty() && latestVersion != VERSION);

    auto now = QDateTime::currentSecsSinceEpoch();
    if (now - model->get_settings()->lastVersionCheckAttempt() > 600 && now - model->get_settings()->lastVersionCheckSuccess() > 86400) {
        model->get_settings()->setLastVersionCheckAttempt(now);

        qInfo() << "Checking github for latest version";
        auto reply = nam.get(QNetworkRequest(QUrl(u"https://api.github.com/repos/fragoulin/LabCompass/releases/latest"_s)));
        connect(reply, &QNetworkReply::finished,
            this, &VersionChecker::onReplyFinished);
    }
}

void VersionChecker::onReplyFinished()
{
    auto reply = reinterpret_cast<QNetworkReply*>(sender());

    if (reply->error() == QNetworkReply::NoError) {
        auto json = QJsonDocument::fromJson(reply->readAll());
        if (json.isObject() && json.object().contains(u"tag_name"_s)) {
            auto object = json.object();
            auto latestVersion = object[u"tag_name"_s].toString();
            model->get_settings()->setLatestVersion(latestVersion);
            model->get_settings()->setLastVersionCheckSuccess(QDateTime::currentSecsSinceEpoch());

            qInfo() << "Received version checking response. Latest version:" << latestVersion;
        }
    }
    reply->deleteLater();
}
