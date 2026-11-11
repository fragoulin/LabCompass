import QtQuick
import labcompass

MouseArea {
  id: root
  property bool shouldDisplayTooltip: false
  hoverEnabled: true

  property TooltipHoverArea lastActiveTooltipHoverArea

  onContainsMouseChanged: {
    if (containsMouse) {
      exitTimer.stop();
      if (lastActiveTooltipHoverArea && lastActiveTooltipHoverArea.shouldDisplayTooltip) {
        lastActiveTooltipHoverArea.shouldDisplayTooltip = false;
        shouldDisplayTooltip = true;
        lastActiveTooltipHoverArea = root;
      } else {
        enterTimer.restart();
      }
    } else {
      enterTimer.stop();
      exitTimer.restart();
    }
  }
  onPressed: (mouse) => {
    enterTimer.stop();
    shouldDisplayTooltip = false;
    mouse.accepted = false;
  }

  Timer {
    id: enterTimer
    interval: 800
    onTriggered: {
      root.shouldDisplayTooltip = true;
      root.lastActiveTooltipHoverArea = root;
    }
  }
  Timer {
    id: exitTimer
    interval: 300
    onTriggered: {
      root.shouldDisplayTooltip = false;
    }
  }
}
