pragma ComponentBehavior: Bound

import QtQuick
import Hyprlandsh.Config
import qs.components
import qs.services

StyledRect {
    id: root

    readonly property color colour: Colours.palette.m3tertiary
    readonly property int padding: Config.bar.clock.background ? Tokens.padding.normal : Tokens.padding.small

    implicitWidth: layout.implicitWidth + root.padding * 2
    implicitHeight: Tokens.sizes.bar.innerWidth

    color: Qt.alpha(Colours.tPalette.m3surfaceContainer, Config.bar.clock.background ? Colours.tPalette.m3surfaceContainer.a : 0)
    radius: Tokens.rounding.full

    Row {
        id: layout

        anchors.centerIn: parent
        spacing: Tokens.spacing.small

        Loader {
            asynchronous: true
            anchors.verticalCenter: parent.verticalCenter

            active: Config.bar.clock.showIcon
            visible: active

            sourceComponent: MaterialIcon {
                text: "calendar_month"
                color: root.colour
            }
        }

        StyledText {
            anchors.verticalCenter: parent.verticalCenter

            visible: Config.bar.clock.showDate

            text: Time.format("ddd d")
            font.pointSize: Tokens.font.size.smaller
            font.family: Tokens.font.family.sans
            color: root.colour
        }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            visible: Config.bar.clock.showDate
            width: visible ? 1 : 0

            height: parent.height * 0.8
            color: root.colour
            opacity: 0.2
        }

        StyledText {
            anchors.verticalCenter: parent.verticalCenter

            text: Time.format(GlobalConfig.services.useTwelveHourClock ? "hh:mm A" : "hh:mm")
            font.pointSize: Tokens.font.size.smaller
            font.family: Tokens.font.family.mono
            color: root.colour
        }
    }
}
