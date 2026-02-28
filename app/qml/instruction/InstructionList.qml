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
    text: qsTr('Unable to locate PoE installation.\n\nYou can try to:\n- run PoE client\n- set the path in Options window.')
  }

  WarningInstructionItem {
    visible: root.inLab && !root.currentRoomDetermined
    text: qsTr('Unable to determine your location.\n\n- Open Planner window and click on your current room.')
  }

  WarningInstructionItem {
    visible: !root.modelValid && root.atPlaza && !root.inLab
    text: qsTr('No map loaded.\n\n- Import a map in Planner window before starting lab.')
  }

  WarningInstructionItem {
    visible: root.modelValid && !Global.loadedMapUpToDate && root.atPlaza && !root.inLab
    text: qsTr('Loaded map is outdated.\n\n- Checkout poelab.com for latest maps.')
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
