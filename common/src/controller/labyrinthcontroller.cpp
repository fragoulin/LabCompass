#include "labyrinthcontroller.h"

LabyrinthController::LabyrinthController(ApplicationModel* labyrinthModel)
{
    this->model = labyrinthModel;
}

void LabyrinthController::importFile(const QString& file)
{
    // file parameter can be prefixed with "file://" if source if FileDialog, but not when loaded from settings
    auto fileToImport = file;
    fileToImport.replace("file://", "");
    qInfo() << "Import:" << fileToImport;

    if (model->loadFromFile(fileToImport)) {
        // update last loaded map date
        model->get_settings()->set_lastLoadedMapDate(model->labyrinthData.date);

        // copy the file to appdata directory
        const auto& appData = QDir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
        const auto& lastLoadedMap = appData.absoluteFilePath("lastLoaded.map");
        appData.mkpath(".");
        if (QFileInfo(fileToImport) != QFileInfo(lastLoadedMap)) {
            QFile::remove(lastLoadedMap);
            QFile::copy(fileToImport, lastLoadedMap);
        }
    } else {
        emit importFileFailed();
    }
}

void LabyrinthController::onRoomPresetSet(const QString& id, const QString& areaCode)
{
    auto& lab = model->labyrinthData;
    if (lab.roomIdIndex.contains(id)) {
        auto& room = lab.rooms[lab.roomIdIndex.value(id)];
        room.areaCode = areaCode;

        lab.normalizeDoorDirections(id);

        model->updateModelOnPresetChange();
    }
}
