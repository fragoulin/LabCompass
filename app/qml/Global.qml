pragma Singleton
import QtQuick

QtObject {
  property string version
  property bool debug: false

  property bool compassVisible: true
  property bool compassToolbarVisible: compassVisible && model && model.roomPresetModel ? model.roomPresetModel.presets.length : false
  property bool plannerWindowOpen: false
  property bool puzzleWindowOpen: false
  property bool optionsWindowOpen: false
  property bool roomPresetsWindowOpen: false
  property MouseArea lastActiveTooltipHoverArea

  property var model
  property bool loadedMapUpToDate: model ? String(model.currentUtcDate) === String(model.labyrinthModel.date) : true

  property color backgroundColor: '#181818'
  property color primaryColor: '#212121'
  property color lightPrimaryColor: '#616161'
  property color primaryTextColor: '#FAFAFA'
  property color secondaryTextColor: '#A0A0A0'
  property color accentColor: '#2196F3'

  property color activePathColor: '#8BC34A'
  property color inactivePathColor: '#404440'

  property var contentIconMapping: {
    'Switch puzzle': 'gauntlet-puzzle',
    'Lever puzzle': 'gauntlet-puzzle',
    'Floor puzzle': 'gauntlet-puzzle',
    'Escort gauntlet': 'gauntlet-puzzle',
    'Trap gauntlet': 'gauntlet-puzzle',
    'darkshrine': 'darkshrine',
    'argus': 'argus',
    'golden-key': 'golden-key',
    'silver-key': 'silver-key',
    'silver-door': 'silver-door'
  }

  property var nameMapping: {
    'Switch puzzle': qsTr('Switch Puzzle'),
    'Lever puzzle': qsTr('Lever Puzzle'),
    'Floor puzzle': qsTr('Floor Puzzle'),
    'Escort gauntlet': qsTr('Escort Gauntlet'),
    'Trap gauntlet': qsTr('Trap Gauntlet'),
    'darkshrine': qsTr('Darkshrine'),
    'argus': qsTr('Argus'),
    'golden-key': qsTr('Golden Key'),
    'golden-door': qsTr('Golden Door'),
    'silver-key': qsTr('Silver Key'),
    'silver-door': qsTr('Silver Cache'),
    'NoPhase': qsTr('Unknown'),
    'ChargeDisruptors': qsTr('Charge Disruptors'),
    'Conduits': qsTr('Conduits'),
    'Essences': qsTr('Essences'),
    'Fonts': qsTr('Fonts'),
    'Gargoyles': qsTr('Gargoyles'),
    'Idols': qsTr('Idols'),
    'Lieutenants': qsTr('Lieutenants'),
    'Portals': qsTr('Portals'),
    'NoTrap': qsTr('Unknown'),
    'BladeSentries': qsTr('Blade Sentries'),
    'Darts': qsTr('Darts'),
    'FurnaceTraps': qsTr('Furnace Traps'),
    'Saws': qsTr('Saws'),
    'Spikes': qsTr('Spikes'),
    'SpinningBlades': qsTr('Spinning Blades'),
    'NoWeapon': qsTr('Unknown'),
    'TwoSwords': qsTr('Two Swords'),
    'SwordAndShield': qsTr('Sword and Shield'),
    'TwoHandedMace': qsTr('Two-handed Mace')
  }

  property var directionMapping: {
    'N': {
      name: qsTr('North'),
      rotation: 0,
      dx: 0,
      dy: -1
    },
    'NE': {
      name: qsTr('Northeast'),
      rotation: 45,
      dx: 0.71,
      dy: -0.71
    },
    'E': {
      name: qsTr('East'),
      rotation: 90,
      dx: 1,
      dy: 0
    },
    'SE': {
      name: qsTr('Southeast'),
      rotation: 135,
      dx: 0.71,
      dy: 0.71
    },
    'S': {
      name: qsTr('South'),
      rotation: 180,
      dx: 0,
      dy: 1
    },
    'SW': {
      name: qsTr('Southwest'),
      rotation: 225,
      dx: -0.71,
      dy: 0.71,
    },
    'W': {
      name: qsTr('West'),
      rotation: 270,
      dx: -1,
      dy: 0
    },
    'NW': {
      name: qsTr('Northwest'),
      rotation: 315,
      dx: -0.71,
      dy: -0.71
    }
  }
}
