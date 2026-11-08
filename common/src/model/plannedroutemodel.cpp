#include "plannedroutemodel.h"

using namespace Qt::StringLiterals;

PlannedRouteModel::PlannedRouteModel()
{
}

void PlannedRouteModel::loadFromData(const NavigationData& data)
{
    beginResetModel();

    d.clear();
    foreach (auto& id, data.plannedRoute) {
        if (id != u"plaza"_s) {
            ModelData modelData;
            modelData.id = id;
            d.append(modelData);
        }
    }

    endResetModel();
}

int PlannedRouteModel::rowCount(const QModelIndex& parent) const
{
    Q_UNUSED(parent)
    return static_cast<int>(d.size());
}

QVariant PlannedRouteModel::data(const QModelIndex& index, int role) const
{
    if (index.row() < 0 || index.row() >= rowCount()) {
        return QVariant();
    }

    const auto& data = d[index.row()];
    switch (role) {
    case IdRole:
        return data.id;
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> PlannedRouteModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    return roles;
}
