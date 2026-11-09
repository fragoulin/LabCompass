#include "application.h"
#include "util/setupdebugoutput.h"
#include "version.h"
using namespace Qt::StringLiterals;

int main(int argc, char** argv)
{
    Q_INIT_RESOURCE(common);
    QApplication::setOrganizationName(u"FutureCode"_s);
    QApplication::setApplicationName(u"LabCompass"_s);

    setupDebugOutput();
    qInfo() << "Operating System:" << QSysInfo::prettyProductName();
    qInfo() << "LabCompass:" << VERSION;

    QSettings settings;
    const auto& scaleFactor = settings.value("scaleFactor", "1").toByteArray();
    if (!qputenv("QT_SCALE_FACTOR", scaleFactor))
        qWarning() << "Failed to set environment variable QT_SCALE_FACTOR";
    qInfo() << "Using scale factor:" << scaleFactor;

    if (!qputenv("QT_QUICK_CONTROLS_MATERIAL_THEME", "Dark"))
        qWarning() << "Failed to set environment variable QT_QUICK_CONTROLS_MATERIAL_THEME";
    if (!qputenv("QT_QUICK_CONTROLS_MATERIAL_ACCENT", "#2196F3"))
        qWarning() << "Failed to set environment variable QT_QUICK_CONTROLS_MATERIAL_ACCENT";

    Application app(argc, argv);
    int r = app.exec();
    qInfo() << "Exiting with code:" << r;
    return r;
}
