#include "roompresethelper.h"

using namespace Qt::StringLiterals;

RoomPresetHelper* RoomPresetHelper::instance = nullptr;

RoomPresetHelper::RoomPresetHelper()
{
    QFile roomPresetsFile(u":/room-presets.json"_s);
    if (!roomPresetsFile.open(QIODevice::ReadOnly)) {
        qCritical() << "Failed to open :/room-presets.json resource";
    }

    const auto& roomTypeList = QJsonDocument::fromJson(roomPresetsFile.readAll()).toVariant().toList();

    for (const auto& roomType : roomTypeList) {
        const auto& roomName = roomType.toMap()[u"roomName"_s].toString();
        const auto& goldenDoor = roomType.toMap()[u"goldenDoor"_s].toBool();
        const auto& variantList = roomType.toMap()[u"variants"_s].toList();

        QPair<QString, bool> index { roomName, goldenDoor };
        cacheByNameAndGoldenDoor.insert(index, {});

        for (const auto& variant : variantList) {
            const auto& preset = variant.toMap();
            const auto& areaCode = preset["areaCode"].toString();

            cacheByAreaCode[areaCode] = preset;
            cacheByNameAndGoldenDoor[index].append({ areaCode, preset });
        }
    }
}

Preset RoomPresetHelper::getPresetByAreaCode(const QString& areaCode) const
{
    return cacheByAreaCode.value(areaCode, {});
}

QList<QPair<QString, Preset>> RoomPresetHelper::getPresetListByName(const QString& roomName, bool goldenDoor) const
{
    QPair<QString, bool> index { roomName, goldenDoor };
    return cacheByNameAndGoldenDoor[index];
}

DoorExitLocationModel RoomPresetHelper::getDoorExitLocationModel(const Preset& preset) const
{
    DoorExitLocationModel result;

    auto list = preset[u"doorLocations"_s].toStringList();
    for (const auto& direction : std::as_const(list))
        result.append(QVariantMap { { u"direction"_s, direction }, { u"tileRect"_s, getTileRect(preset, direction) } });

    return result;
}

ContentLocationModel RoomPresetHelper::getContentLocationModel(const Preset& preset, bool generalLocations, bool majorLocations, bool minorLocations)
{
    ContentLocationModel result;

    const auto& contentLocations = preset["contentLocations"].toMap();

    if (generalLocations && contentLocations.contains(u"generic"_s)) {
        auto list = contentLocations[u"generic"_s].toStringList();
        for (const auto& direction : std::as_const(list))
            result.append(QVariantMap { { u"direction"_s, direction }, { u"major"_s, false }, { u"tileRect"_s, getTileRect(preset, direction) } });
    }

    if (majorLocations && contentLocations.contains(u"major"_s)) {
        auto list = contentLocations[u"major"_s].toStringList();
        for (const auto& direction : std::as_const(list))
            result.append(QVariantMap { { u"direction"_s, direction }, { u"major"_s, true }, { u"tileRect"_s, getTileRect(preset, direction) } });
    }

    if (minorLocations && contentLocations.contains(u"minor"_s)) {
        auto list = contentLocations["minor"].toStringList();
        for (const auto& direction : std::as_const(list))
            result.append(QVariantMap { { u"direction"_s, direction }, { u"major"_s, false }, { u"tileRect"_s, getTileRect(preset, direction) } });
    }

    return result;
}

QRectF RoomPresetHelper::getTileRect(const Preset& preset, const QString& direction) const
{
    const auto& coord = preset[u"minimap"_s].toMap()[u"directions"_s].toMap()[direction].toList();
    int row = coord[0].toInt();
    int column = coord[1].toInt();
    int rows = preset[u"minimap"_s].toMap()[u"rows"_s].toInt();
    int columns = preset[u"minimap"_s].toMap()[u"columns"_s].toInt();
    qreal rowd = row - (rows - 1) / 2.0;
    qreal columnd = column - (columns - 1) / 2.0;
    qreal scale = 10.0 / std::max(std::max(rows, columns), 7);
    const auto& d = QPointF(columnd - rowd, columnd + rowd) * 0.05 * scale;
    const auto& tileCenter = QPointF(0.5, 0.5) + d;
    return QRectF(tileCenter.x() - 0.05 * scale, tileCenter.y() - 0.05 * scale,
        0.1 * scale, 0.1 * scale);
}
