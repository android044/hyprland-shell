pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Hyprlandsh.Config
import qs.components
import qs.services
import qs.utils

RowLayout {
    id: root

    required property int index
    required property int activeWsId
    required property var occupied
    required property int groupOffset
    required property real iconExtra
    required property bool indicatorSliding
    required property real indicatorOffset
    required property real indicatorSize

    readonly property bool indicatorCovers: indicatorOffset < x + width
                                         && indicatorOffset + indicatorSize > x

    readonly property bool isWorkspace: true // Flag for finding workspace children
    readonly property bool isActive: activeWsId === ws
    // Reserve the exact space the indicator's appIcon occupies (received from ActiveIndicator)
    readonly property real iconReserve: isActive ? iconExtra : 0
    // Unanimated prop for others to use as reference
    readonly property int size: implicitWidth + (hasWindows ? Tokens.padding.small : 0) + iconReserve

    readonly property int ws: groupOffset + index + 1
    readonly property bool isOccupied: occupied[ws] ?? false
    readonly property bool hasWindows: isOccupied && Config.bar.workspaces.showWindows

    Layout.alignment: Qt.AlignVCenter
    Layout.preferredWidth: size

    spacing: 0

    StyledText {
        id: indicator

        Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
        Layout.preferredWidth: Tokens.sizes.bar.innerWidth - Tokens.padding.small * 2

        animate: true
        text: {
            const ws = Hypr.workspaces.values.find(w => w.id === root.ws);
            const wsName = !ws || ws.name == root.ws ? root.ws : ws.name[0];
            let displayName = wsName.toString();
            if (Config.bar.workspaces.capitalisation.toLowerCase() === "upper") {
                displayName = displayName.toUpperCase();
            } else if (Config.bar.workspaces.capitalisation.toLowerCase() === "lower") {
                displayName = displayName.toLowerCase();
            }
            const label = Config.bar.workspaces.label || displayName;
            const occupiedLabel = Config.bar.workspaces.occupiedLabel || label;
            const activeLabel = Config.bar.workspaces.activeLabel || (root.isOccupied ? occupiedLabel : label);
            return root.activeWsId === root.ws ? activeLabel : root.isOccupied ? occupiedLabel : label;
        }
        color: Config.bar.workspaces.occupiedBg || root.isOccupied || root.activeWsId === root.ws ? Colours.palette.m3onSurface : Colours.layer(Colours.palette.m3outlineVariant, 2)
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
    }

    Loader {
        id: windows

        asynchronous: true

        Layout.alignment: Qt.AlignVCenter
        Layout.fillWidth: true
        Layout.leftMargin: -Tokens.sizes.bar.innerWidth / 10

        visible: active
        active: root.hasWindows && !root.isActive
        // Hide (don't unload) while the sliding indicator passes over, so the icon
        // doesn't poke out from under the pill. Opacity keeps the layout slot stable;
        // toggling `active` here would change implicitWidth and create a polish loop,
        // since the indicator's offset/size are derived from this RowLayout's geometry.
        opacity: root.indicatorSliding && root.indicatorCovers ? 0 : 1

        sourceComponent: MaterialIcon {
            grade: 0
            animate: true

            text: {
                const wins = Hypr.toplevels.values.filter(c => c.workspace?.id === root.ws);
                const lastAddr = Hypr.workspaces.values.find(w => w.id === root.ws)?.lastIpcObject.lastwindow;
                const focused = wins.find(c => c.lastIpcObject.address === lastAddr) ?? wins[0];
                return Icons.getAppCategoryIcon(focused?.lastIpcObject.class ?? "", "terminal");
            }
            color: Colours.palette.m3onSurfaceVariant
        }
    }

}
