#include "labyrinthdata.h"
#include "labyrinthmodel.h"

LabyrinthModel::LabyrinthModel(QObject* parent)
    : QObject(parent)
{
}

void LabyrinthModel::loadFromData(const LabyrinthData& data)
{
    update_difficulty(data.difficulty);
    update_date(data.date);
}
