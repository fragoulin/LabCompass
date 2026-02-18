#include "stdafx.h"

bool isWaylandDisplay()
{
    return "wayland" == qEnvironmentVariable("XDG_SESSION_TYPE");
}
