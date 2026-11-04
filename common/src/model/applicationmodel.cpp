#include "applicationmodel.h"

ApplicationModel::ApplicationModel(QObject* parent)
    : QObject(parent)
{
    update_settings(new Settings());
    get_settings()->load();

    m_labyrinthModel.reset(new LabyrinthModel);
    m_roomModel.reset(new RoomModel);
    m_connectionModel.reset(new ConnectionModel);
    m_plannedRouteModel.reset(new PlannedRouteModel);
    m_goldenDoorModel.reset(new GoldenDoorModel);
    m_instructionModel.reset(new InstructionModel);
    m_planSummaryModel.reset(new PlanSummaryModel);
    m_roomPresetModel.reset(new RoomPresetModel);

    m_newVersionAvailable = false;
    m_logFileOpen = true;
    m_atPlaza = false;
    m_inLab = false;
    m_currentRoomDetermined = true;
    m_isValid = false;
}

bool ApplicationModel::loadFromFile(const QString& file)
{
    LabyrinthData newLabyrinthData;
    if (newLabyrinthData.loadFromFile(file)) {
        labyrinthData = newLabyrinthData;
        updatePlanData(PlanData());

        update_inLab(false);
        update_isValid(true);
        updateModelOnLoadFile();
        return true;
    }
    return false;
}

void ApplicationModel::updatePlanData(const PlanData& newPlanData)
{
    this->planData = newPlanData;
    NavigationData data;
    data.loadFromData(&labyrinthData, planData);
    data.updatePlannedRouteAndInstructions();

    get_planSummaryModel()->loadFromData(data);
    updateNavigationData(data);
}

void ApplicationModel::updateNavigationData(const NavigationData& newNavigationData)
{
    this->navigationData = newNavigationData;
    update_currentRoomDetermined(navigationData.currentRoomDetermined);
    updateModelOnNavigation();
}

void ApplicationModel::updateModelOnLoadFile()
{
    get_labyrinthModel()->loadFromData(labyrinthData);
    get_roomModel()->loadFromData(labyrinthData, navigationData);
    get_connectionModel()->loadFromData(labyrinthData, navigationData);
    get_goldenDoorModel()->loadFromData(labyrinthData);
    get_plannedRouteModel()->loadFromData(navigationData);
    get_instructionModel()->loadFromData(navigationData);
    get_roomPresetModel()->loadFromData(navigationData);
}

void ApplicationModel::updateModelOnNavigation()
{
    get_roomModel()->updateFromData(navigationData);
    get_connectionModel()->updateFromData(navigationData);
    get_plannedRouteModel()->loadFromData(navigationData);
    get_instructionModel()->loadFromData(navigationData);
    get_roomPresetModel()->loadFromData(navigationData);
}

void ApplicationModel::updateModelOnPresetChange()
{
    get_instructionModel()->loadFromData(navigationData);
    get_roomPresetModel()->loadFromData(navigationData);
}
