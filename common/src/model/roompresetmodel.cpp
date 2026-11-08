#include "helper/roompresethelper.h"
#include "roompresetmodel.h"

using namespace Qt::StringLiterals;

RoomPresetModel::RoomPresetModel(QObject* parent)
    : QObject(parent)
{
    m_current = -1;
}

void RoomPresetModel::loadFromData(const NavigationData& data)
{
    if (!data.currentRoomDetermined) {
        update_roomId(QString());
        update_roomName(QString());
        update_current(-1);
        update_presets({});

    } else {
        const auto& room = data.lab->getRoomFromId(data.currentRoom);
        update_roomId(room.id);
        update_roomName(room.name);

        auto helper = RoomPresetHelper::instance;
        const auto& presetList = helper->getPresetListByName(room.name, room.contents.contains(u"golden-door"_s));

        QVariantList presetsModel;
        int current = -1;

        if (!presetList.isEmpty()) {
            update_current(current);
            for (auto i = presetList.size() - 1; i >= 0; i--) {
                const auto& preset = presetList[i].second;
                QVariantMap item;
                item[u"areaCode"_s] = preset[u"areaCode"_s];
                item[u"doorExitLocations"_s] = helper->getDoorExitLocationModel(preset);
                item[u"contentLocations"_s] = helper->getContentLocationModel(preset);
                presetsModel.append(item);

                if (item[u"areaCode"_s].toString() == room.areaCode) {
                    current = static_cast<int>(presetList.size()) - 1 - static_cast<int>(i);
                }
            }

            presetsModel.append(QVariantMap { { u"areaCode"_s, u"disabled"_s }, { u"doorExitLocations"_s, QVariantList {} }, { u"contentLocations"_s, QVariantList {} } });
            if (room.areaCode == u"disabled"_s) {
                current = static_cast<int>(presetsModel.size()) - 1;
            }
        }

        update_current(current);
        update_presets(presetsModel);
    }
}
