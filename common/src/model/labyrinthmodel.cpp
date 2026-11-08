#include "labyrinthdata.h"
#include "labyrinthmodel.h"

LabyrinthModel::LabyrinthModel(QObject* parent)
    : QObject(parent)
{
}

void LabyrinthModel::loadFromData(const LabyrinthData& data)
{
    switch (data.difficulty) {
        case LabyrinthData::Difficulty::NORMAL:
             update_difficulty(Difficulty::NORMAL);
            break;
        case LabyrinthData::Difficulty::CRUEL:
            update_difficulty(Difficulty::CRUEL);
            break;
        case LabyrinthData::Difficulty::MERCILESS:
            update_difficulty(Difficulty::MERCILESS);
            break;
        case LabyrinthData::Difficulty::UBER:
            update_difficulty(Difficulty::ETERNAL);
            break;
    }

    update_date(data.date);
}
