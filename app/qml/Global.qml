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
    //: Switch puzzle label in the labyrinth planner
    //% "Switch Puzzle"
    //@ Labyrinth
    'Switch puzzle': qsTrId("id-switch-puzzle"),
    //: Lever puzzle label in the labyrinth planner
    //% "Lever Puzzle"
    //@ Labyrinth
    'Lever puzzle': qsTrId("id-lever-puzzle"),
    //: Floor puzzle label in the labyrinth planner
    //% "Floor Puzzle"
    //@ Labyrinth
    'Floor puzzle': qsTrId("id-floor-puzzle"),
    //: Escort gauntlet label in the labyrinth planner
    //% "Escort Gauntlet"
    //@ Labyrinth
    'Escort gauntlet': qsTrId("id-escort-gauntlet"),
    //: Trap gauntlet label in the labyrinth planner
    //% "Trap Gauntlet"
    //@ Labyrinth
    'Trap gauntlet': qsTrId("id-trap-gauntlet"),
    //: Darkshrine label in the labyrinth planner
    //% "Darkshrine"
    //@ Labyrinth
    'darkshrine': qsTrId("id-darkshrine"),
    //: Argus label in the labyrinth planner
    //% "Argus"
    //@ Labyrinth
    'argus': qsTrId("id-argus"),
    //: Golden Key label in the labyrinth planner
    //% "Golden Key"
    //@ Labyrinth
    'golden-key': qsTrId("id-golden-key"),
    //: Golden Door label in the labyrinth planner
    //% "Golden Door"
    //@ Labyrinth
    'golden-door': qsTrId("id-golden-door"),
    //: Silver Key label in the labyrinth planner
    //% "Silver Key"
    //@ Labyrinth
    'silver-key': qsTrId("id-silver-key"),
    //: Silver Cache label in the labyrinth planner
    //% "Silver Cache"
    //@ Labyrinth
    'silver-door': qsTrId("id-silver-door"),
    //: Unknown phase during Izaro fight. Should never happen
    //% "Unknown"
    //@ Labyrinth
    'NoPhase': qsTrId("id-no-phase"),
    //: Charge Disruptors during Izaro fight
    //% "Charge Disruptors"
    //@ Labyrinth
    'ChargeDisruptors': qsTrId("id-charge-disruptors"),
    //: Conduits during Izaro fight
    //% "Conduits"
    //@ Labyrinth
    'Conduits': qsTrId("id-conduits"),
    //: Essences during Izaro fight
    //% "Essences"
    //@ Labyrinth
    'Essences': qsTrId("id-essences"),
    //: Fonts during Izaro fight
    //% "Fonts"
    //@ Labyrinth
    'Fonts': qsTrId("id-fonts"),
    //: Gargoyles during Izaro fight
    //% "Gargoyles"
    //@ Labyrinth
    'Gargoyles': qsTrId("id-gargoyles"),
    //: Idols during Izaro fight
    //% "Idols"
    //@ Labyrinth
    'Idols': qsTrId("id-idols"),
    //: Lieutenants during Izaro fight
    //% "Lieutenants"
    //@ Labyrinth
    'Lieutenants': qsTrId("id-lieutenants"),
    //: Portals during Izaro fight
    //% "Portals"
    //@ Labyrinth
    'Portals': qsTrId("id-portals"),
    //: No trap in the current room. Should never happen
    //% "Unknown"
    //@ Labyrinth
    'NoTrap': qsTrId("id-no-trap"),
    //: Blade Sentries in the current room
    //% "Blade Sentries"
    //@ Labyrinth
    'BladeSentries': qsTrId("id-blade-sentries"),
    //: Darts in the current room
    //% "Darts"
    //@ Labyrinth
    'Darts': qsTrId("id-darts"),
    //: Furnace Traps in the current room
    //% "Furnace Traps"
    //@ Labyrinth
    'FurnaceTraps': qsTrId("id-furnace-traps"),
    //: Saws in the current room
    //% "Saws"
    //@ Labyrinth
    'Saws': qsTrId("id-saws"),
    //: Spikes in the current room
    //% "Spikes"
    //@ Labyrinth
    'Spikes': qsTrId("id-spikes"),
    //: Spinning Blades in the current room
    //% "Spinning Blades"
    //@ Labyrinth
    'SpinningBlades': qsTrId("id-spinning-blades"),
    //: No weapon for Izaro. Should never happen
    //% "Unknown"
    //@ Labyrinth
    'NoWeapon': qsTrId("id-no-weapon"),
    //: Two Swords for Izaro
    //% "Two Swords"
    //@ Labyrinth
    'TwoSwords': qsTrId("id-two-swords"),
    //: Sword and Shield for Izaro
    //% "Sword and Shield"
    //@ Labyrinth
    'SwordAndShield': qsTrId("id-sword-and-shield"),
    //: Two-handed Mace for Izaro
    //% "Two-handed Mace"
    //@ Labyrinth
    'TwoHandedMace': qsTrId("id-two-handed-mace")
  }

  property var directionMapping: {
    'N': {
      //: North label for direction
      //% "North"
      //@ Labyrinth
      name: qsTrId("id-north"),
      rotation: 0,
      dx: 0,
      dy: -1
    },
    'NE': {
      //: Northeast label for direction
      //% "Northeast"
      //@ Labyrinth
      name: qsTrId("id-northeast"),
      rotation: 45,
      dx: 0.71,
      dy: -0.71
    },
    'E': {
      //: East label for direction
      //% "East"
      //@ Labyrinth
      name: qsTrId("id-east"),
      rotation: 90,
      dx: 1,
      dy: 0
    },
    'SE': {
      //: Southeast label for direction
      //% "Southeast"
      //@ Labyrinth
      name: qsTrId("id-southeast"),
      rotation: 135,
      dx: 0.71,
      dy: 0.71
    },
    'S': {
      //: South label for direction
      //% "South"
      //@ Labyrinth
      name: qsTrId("id-south"),
      rotation: 180,
      dx: 0,
      dy: 1
    },
    'SW': {
      //: Southwest label for direction
      //% "Southwest"
      //@ Labyrinth
      name: qsTrId("id-southwest"),
      rotation: 225,
      dx: -0.71,
      dy: 0.71,
    },
    'W': {
      //: West label for direction
      //% "West"
      //@ Labyrinth
      name: qsTrId("id-west"),
      rotation: 270,
      dx: -1,
      dy: 0
    },
    'NW': {
      //: Northwest label for direction
      //% "Northwest"
      //@ Labyrinth
      name: qsTrId("id-northwest"),
      rotation: 315,
      dx: -0.71,
      dy: -0.71
    }
  }
}
