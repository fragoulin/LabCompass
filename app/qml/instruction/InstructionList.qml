import QtQuick
import labcompass

Column {
  id: root

  property bool modelValid: Global.model.isValid
  property bool atPlaza: Global.model.atPlaza
  property bool inLab: Global.model.inLab
  property bool currentRoomDetermined: Global.model.currentRoomDetermined
  property bool showInstructions: modelValid && inLab && currentRoomDetermined
  property var instructionModel: Global.model.instructionModel

  WarningInstructionItem {
    visible: !Global.model.logFileOpen
    //: Warning displayed when the POE installation cannot be located, with an invitaion to open file dialog. The warning message must be brief because of limited space in the UI
    //% "Unable to locate PoE installation.\n\nYou can try to:\n- run PoE client\n- set the path in Options window."
    //@ Warning
    text: qsTrId("id-warning-unable-to-locate-poe-installation")
  }

  WarningInstructionItem {
    visible: root.inLab && !root.currentRoomDetermined
    //: Warning displayed when the player location in labyrinth cannot be determined, with an invitation to open planner and choose a location. The warning message must be brief because of limited space in the UI
    //% "Unable to determine your location.\n\n- Open Planner window and click on your current room."
    //@ Warning
    text: qsTrId("id-warning-unable-to-determine-location-in-lab")
  }

  WarningInstructionItem {
    visible: !root.modelValid && root.atPlaza && !root.inLab
    //: Warning displayed when no map is loaded, with an invitation to import a map in the planner window. The warning message must be brief because of limited space in the UI
    //% "No map loaded.\n\n- Import a map in Planner window before starting lab."
    //@ Warning
    text: qsTrId("id-warning-no-map-loaded")
  }

  WarningInstructionItem {
    visible: root.modelValid && !Global.loadedMapUpToDate && root.atPlaza && !root.inLab
    //: Warning displayed when the map loaded in the planner is outdated, with an invitation to download the latest map. The warning message must be brief because of limited space in the UI
    //% "Loaded map is outdated.\n\n- Checkout poelab.com for latest maps."
    //@ Warning
    text: qsTrId("id-warning-outdated-map")
  }

  LoadedMapInstructionItem {
    visible: root.modelValid && root.atPlaza && !root.inLab
    model: Global.model.labyrinthModel
  }

  IzaroInstructionItem {
    id: izaroInstructionItem
    visible: root.showInstructions &&
             root.instructionModel.atTrialRoom &&
             root.instructionModel.shouldKillIzaro &&
             root.instructionModel.finishedSections <= root.instructionModel.currentSection
    mechanics: root.instructionModel.izaroMechanics
  }

  DirectionInstructionItem {
    visible: root.showInstructions &&
             root.instructionModel.hasNextRoom &&
             (connectionType === 'door' || connectionType === 'secret') &&
             (!instructionModel.atTrialRoom || !instructionModel.shouldKillIzaro || instructionModel.finishedSections > instructionModel.currentSection)
    connectionType: root.instructionModel.nextRoomConnectionType
    direction: root.instructionModel.nextRoomDirection
    nextRoomName: root.instructionModel.nextRoomName
    atPlaza: root.atPlaza
    nextRoomIsPreviousRoom: root.instructionModel.nextRoomIsPreviousRoom
    nextRoomIsUnmarkedOppositeDirection: root.instructionModel. nextRoomIsUnmarkedOppositeDirection
  }

  LootInstructionItem {
    visible: root.showInstructions && root.instructionModel.roomLoot.length
    model: root.instructionModel.roomLoot
  }

  Item { width: 1; height: 1 }

  Connections {
    target: logWatcher
    ignoreUnknownSignals: true
    function onRoomChanged() {
      if (typeof izaroInstructionItemIcon !== "undefined") {
        izaroInstructionItemIcon.state = ''
      }
    }
    function onIzaroBattleStarted() {
      if (typeof izaroInstructionItem !== "undefined") {
        izaroInstructionItem.onIzaroBattleStarted()
      }
    }
  }
}
