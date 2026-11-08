#include "plansummarymodel.h"

using namespace Qt::StringLiterals;

static const QStringList TROVE_LIST {
    u"Switch puzzle"_s,
    u"Floor puzzle"_s,
    u"Escort gauntlet"_s,
    u"Trap gauntlet"_s,
};

PlanSummaryModel::PlanSummaryModel(QObject* parent)
    : QObject(parent)
{
    m_rooms = 0;
    m_length = 0;
    m_argus = 0;
    m_troves = 0;
    m_darkshrines = 0;
    m_silverCaches = 0;
}

void PlanSummaryModel::loadFromData(const NavigationData& data)
{
    QList<RoomId> rooms;
    int argus = 0;
    int troves = 0;
    int darkshrines = 0;
    int silverCaches = 0;
    int unusedSilverKeys = 0;

    for (const auto& roomId : data.plannedRoute) {
        if (roomId != u"plaza"_s && !rooms.contains(roomId)) {
            rooms.append(roomId);
        }
    }

    for (const auto& roomId : rooms) {
        auto room = data.lab->getRoomFromId(roomId);
        auto roomContents = room.contents;

        for (const auto& content : roomContents) {
            if (content == u"argus"_s)
                argus += 1;
            if (content == u"darkshrine"_s)
                darkshrines += 1;
            if (content == u"silver-key"_s)
                unusedSilverKeys += 1;
            if (TROVE_LIST.contains(content))
                troves += 1;
        }

        for (const auto& content : roomContents) {
            if (content == u"silver-door"_s && unusedSilverKeys > 0) {
                silverCaches += 1;
                unusedSilverKeys -= 1;
            }
        }
    }

    update_rooms(static_cast<int>(rooms.size()) - 3); // exclude 3 trial rooms
    update_length(static_cast<int>(data.plannedRoute.size()) - 1); // exclude plaza
    update_argus(argus);
    update_troves(troves);
    update_darkshrines(darkshrines);
    update_silverCaches(silverCaches);
}
