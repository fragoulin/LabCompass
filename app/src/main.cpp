#include "application.h"
#include "util/setupdebugoutput.h"
#include "version.h"
using namespace Qt::StringLiterals;

#ifdef Q_OS_WIN
// Indicates to hybrid graphics systems to prefer the discrete part by default.
extern "C" {
Q_DECL_EXPORT unsigned long NvOptimusEnablement = 0x00000001;
Q_DECL_EXPORT int AmdPowerXpressRequestHighPerformance = 1;
}
#endif
int main(int argc, char** argv)
{
    if (!qputenv("QT_QUICK_CONTROLS_STYLE", "Basic"))
        qWarning() << "Failed to set environment variable QT_QUICK_CONTROLS_STYLE";
#ifdef Q_OS_WINDOWS
    if (!qputenv("QSG_RHI_BACKEND", "d3d11")) // options: d3d11, d3d12, opengl, vulkan
        qWarning() << "Failed to set environment variable QSG_RHI_BACKEND";
    if (!qputenv("QT_QPA_DISABLE_REDIRECTION_SURFACE", "1"))
        qWarning() << "Failed to set environment variable QT_QPA_DISABLE_REDIRECTION_SURFACE";
#endif

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

    QGuiApplication::setHighDpiScaleFactorRoundingPolicy(
        Qt::HighDpiScaleFactorRoundingPolicy::PassThrough);

    QLoggingCategory::setFilterRules(u"qt.qpa.screen.updates=true"_s);

    Application app(argc, argv);
    int r = app.exec();
    qInfo() << "Exiting with code:" << r;
    return r;
}
