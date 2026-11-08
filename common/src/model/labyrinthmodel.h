#ifndef LABYRINTHMODEL_H
#define LABYRINTHMODEL_H

#include "model/labyrinthdata.h"

class LabyrinthModel : public QObject {
    Q_OBJECT

    enum Difficulty {
        NORMAL,
        CRUEL,
        MERCILESS,
        ETERNAL
    };

    QML_READONLY_VAR_PROPERTY(Difficulty, difficulty)
    QML_READONLY_VAR_PROPERTY(QDate, date)

public:
    LabyrinthModel(QObject* parent = nullptr);
    void loadFromData(const LabyrinthData& data);
};

#endif // LABYRINTHMODEL_H
