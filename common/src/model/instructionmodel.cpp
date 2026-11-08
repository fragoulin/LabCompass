#include "helper/roompresethelper.h"
#include "instructionmodel.h"

using namespace Qt::StringLiterals;

Q_GLOBAL_STATIC(QStringList, LOOT_LIST, {
     u"Switch puzzle"_s,
     u"Floor puzzle"_s,
     u"Escort gauntlet"_s,
     u"Trap gauntlet"_s,
     u"darkshrine"_s,
     u"argus"_s,
     u"golden-key"_s,
     u"silver-key"_s,
     u"silver-door"_s,
 })

Q_GLOBAL_STATIC(QStringList, MAJOR_LOOT_LIST, {
    u"golden-key"_s,
    u"silver-key"_s,
    u"silver-door"_s,
})

Q_GLOBAL_STATIC(QList<DirectionCode>, REGULAR_DIRECTION_LIST, {
    u"N"_s, u"NE"_s, u"E"_s, u"SE"_s, u"S"_s, u"SW"_s, u"W"_s, u"NW"_s
})

InstructionModel::InstructionModel(QObject* parent)
    : QObject(parent)
{
    m_roomHasPortal = false;
    m_atTrialRoom = false;
    m_hasNextRoom = false;
    m_nextRoomIsPreviousRoom = false;
    m_nextRoomIsUnmarkedOppositeDirection = false;
    m_finishedSections = 0;
    m_currentSection = -1;
    m_shouldKillIzaro = false;
}

void InstructionModel::loadFromData(const NavigationData& data)
{
    if (!data.currentRoomDetermined)
        return;

    updateRoomPreset(data);

    updateContentsAndLocations(data);

    updateExitLocations(data);

    update_currentSection(data.lab->getRoomFromId(data.currentRoom).section);

    update_roomHasPortal(false);

    update_atTrialRoom(data.lab->roomIsTrial(data.currentRoom));

    update_hasNextRoom(data.plannedRoute.size() >= 2);

    if (get_hasNextRoom()) {
        auto nextRoomId = data.plannedRoute[1];
        auto roomConnections = data.lab->getRoomConnections(data.currentRoom);
        auto connections = roomConnections[nextRoomId];

        update_nextRoomIsPreviousRoom(nextRoomId == data.previousRoom);

        update_nextRoomIsUnmarkedOppositeDirection(!get_nextRoomIsPreviousRoom() && data.lab->roomIsTrial(data.currentRoom) && data.lab->getRoomFromId(data.currentRoom).section == data.lab->getRoomFromId(nextRoomId).section);

        update_nextRoomName(data.lab->getRoomFromId(nextRoomId).nameId);

        if (connections.isEmpty())
            update_nextRoomConnectionType(u"none"_s); // should not happen
        else if (connections.contains(u"P"_s))
            update_nextRoomConnectionType(u"portal"_s);
        else if (connections.first() == u"C"_s)
            update_nextRoomConnectionType(u"secret"_s);
        else
            update_nextRoomConnectionType(u"door"_s);

        update_nextRoomDirection(connections.isEmpty() ? "" : connections.first());
    }

    if (data.lab->roomIsTrial(data.currentRoom)) {
        update_shouldKillIzaro(data.plannedRoute.size() < 2 || data.lab->getRoomFromId(data.currentRoom).section < data.lab->getRoomFromId(data.plannedRoute[1]).section);

        update_izaroMechanics(get_currentSection() < 2 ? data.lab->sectionMechanics[get_currentSection()] : "");
    }
}

void InstructionModel::updateRoomPreset(const NavigationData& data)
{
    const auto& room = data.lab->getRoomFromId(data.currentRoom);
    const auto& helper = RoomPresetHelper::instance;
    const auto& preset = helper->getPresetByAreaCode(room.areaCode);
    update_preset(preset);
}

void InstructionModel::updateExitLocations(const NavigationData& data)
{
    const auto& room = data.lab->getRoomFromId(data.currentRoom);
    const auto& helper = RoomPresetHelper::instance;
    const auto& preset = helper->getPresetByAreaCode(room.areaCode);

    QVariantList doorExitLocations;

    if (preset.isEmpty()) {
        const auto& exits = data.lab->getRoomConnections(data.currentRoom);
        for (const auto& l : exits)
            for (const auto& direction : l)
                if (REGULAR_DIRECTION_LIST->contains(direction))
                    doorExitLocations.append(QVariantMap { { u"direction"_s, direction }, { u"tileRect"_s, QRectF() } });

    } else {
        doorExitLocations = helper->getDoorExitLocationModel(preset);
    }

    update_doorExitLocations(doorExitLocations);
}

void InstructionModel::updateContentsAndLocations(const NavigationData& data)
{
    const auto& room = data.lab->getRoomFromId(data.currentRoom);
    const auto& contents = room.contents;
    QStringList loot;
    QStringList majorLoot;
    QStringList minorLoot;

    const auto& helper = RoomPresetHelper::instance;
    const auto& preset = helper->getPresetByAreaCode(room.areaCode);

    for (const auto& content : contents)
        if (LOOT_LIST->contains(content)) {
            loot.append(content);
            if (MAJOR_LOOT_LIST->contains(content))
                majorLoot.append(content);
            else
                minorLoot.append(content);
        }
    update_roomLoot(loot);

    if (data.lab->roomHasSecretPassage(data.currentRoom)) {
        loot.append(u"secret_passage"_s);
        minorLoot.append(u"secret_passage"_s);
    }

    QVariantList visibleContentLocations;
    if (!loot.isEmpty())
        visibleContentLocations = helper->getContentLocationModel(preset, true, !majorLoot.isEmpty(), !minorLoot.isEmpty());

    update_contentLocations(visibleContentLocations);
}
