pragma Singleton
import QtQuick 2.0

QtObject {
    readonly property color strongTextColor: "#efefef"
    readonly property string strongTextFont: "Roboto"
    readonly property int strongTextSize: 10

    readonly property color weakTextColor: "#6b6b78"
    readonly property string weakTextFont: "Roboto"
    readonly property int weakTextSize: 10

    readonly property color logoTextColor: "#eeefef"
    readonly property int logoTextSize: 24

    readonly property color panelBackgroundColor: "#1a1c20"
    readonly property color panelSeparatorColor: "#101010"

    readonly property color highlightAffirmative: "#32b10e"
    readonly property color highlightNeutral: "#746c53"
    readonly property color highlightNegative: "#cc163d"

    readonly property color textInputBackgroundColor: Qt.darker(panelBackgroundColor, 2.5)

    readonly property color lokiDarkGreen: "#008522"
    readonly property color lokiFontWhite: logoTextColor
    readonly property color errorRed: highlightNegative

    // app dimensions -- TODO: components should be sized dynamically,
    // this should either be defined/used in one place or implied by
    // the desired size of widgets
    readonly property int appWidth: 300
}
