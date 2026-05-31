pragma ComponentBehavior: Bound

import QtQuick
import Hyprlandsh.Config
import qs.components
import qs.components.effects
import qs.services
import qs.utils

StyledRect {
    id: root

    required property int activeWsId
    required property Repeater workspaces
    required property Item mask
    required property bool fullscreen
    required property bool hasActiveWindow

    readonly property int currentWsIdx: {
        let i = activeWsId - 1;
        while (i < 0)
            i += Config.bar.workspaces.shown;
        return i % Config.bar.workspaces.shown;
    }

    property real leading: workspaces.count > 0 ? workspaces.itemAt(currentWsIdx)?.x ?? 0 : 0
    property real trailing: workspaces.count > 0 ? workspaces.itemAt(currentWsIdx)?.x ?? 0 : 0
    property real currentSize: workspaces.count > 0 ? Tokens.sizes.bar.innerWidth - Tokens.padding.small * 2 : 0
    property real wsOffset: Math.min(leading, trailing)
    property real offset: wsOffset
    // Reserve icon space whenever the active workspace has a window. Must NOT depend on
    // `sliding`: this width feeds the active Workspace's iconReserve and the container's
    // implicitWidth, so gating it on a navigation-transient flag collapses the pill to a
    // circle and shrinks the whole container on every workspace switch.
    readonly property real iconExtra: hasActiveWindow ? (appIcon.implicitWidth + Math.floor(Tokens.sizes.bar.innerWidth / 10)) : 0
    property real size: {
        const s = Math.abs(leading - trailing) + currentSize + root.iconExtra;
        if (Config.bar.workspaces.activeTrail && lastWs > currentWsIdx) {
            const ws = workspaces.itemAt(lastWs) as Workspace;
            return ws ? Math.min(ws.x + ws.size - wsOffset, s) : 0;
        }
        return s;
    }

    property int cWs
    property int lastWs
    property bool sliding: false

    onCurrentWsIdxChanged: {
        lastWs = cWs;
        cWs = currentWsIdx;
        sliding = true;
        slideEndTimer.restart();
    }

    Timer {
        id: slideEndTimer
        // trailing Behavior uses small * 2; wait at least that long before showing the icon
        interval: Tokens.anim.durations.small * 2
        onTriggered: root.sliding = false
    }

    clip: true
    x: offset + mask.x
    implicitWidth: size
    implicitHeight: Tokens.sizes.bar.innerWidth - Tokens.padding.small * 2
    radius: Tokens.rounding.full
    color: Colours.palette.m3primary

    Item {
        clip: true
        width: root.currentSize
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        Colouriser {
            source: root.mask
            sourceColor: Colours.palette.m3onSurface
            colorizationColor: Colours.palette.m3onPrimary

            x: -root.offset
            y: 0
            implicitWidth: root.mask.implicitWidth
            implicitHeight: root.mask.implicitHeight

            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MaterialIcon {
        id: appIcon

        x: root.currentSize - Math.floor(Tokens.sizes.bar.innerWidth / 10)
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 1

        animate: true
        visible: root.hasActiveWindow
        text: Icons.getAppCategoryIcon(Hypr.activeToplevel?.lastIpcObject.class, "desktop_windows")
        color: Colours.palette.m3onPrimary
    }

    Behavior on leading {
        enabled: root.Config.bar.workspaces.activeTrail

        EAnim {}
    }

    Behavior on trailing {
        enabled: root.Config.bar.workspaces.activeTrail

        EAnim {
            duration: Tokens.anim.durations.small * 2
        }
    }

    Behavior on currentSize {
        enabled: root.Config.bar.workspaces.activeTrail

        EAnim {}
    }

    Behavior on offset {
        enabled: !root.Config.bar.workspaces.activeTrail

        EAnim {}
    }

    Behavior on size {
        enabled: !root.Config.bar.workspaces.activeTrail

        EAnim {}
    }

    Behavior on x {
        enabled: !root.Config.bar.workspaces.activeTrail

        EAnim {}
    }

    component EAnim: Anim {
        type: Anim.EmphasizedSmall
    }
}
