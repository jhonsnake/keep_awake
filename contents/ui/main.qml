import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasma5support as P5Support

PlasmoidItem {
    id: root

    property bool awake: false
    // kde-inhibit holds the inhibition for as long as the child command runs.
    // "sleep infinity" keeps it alive until we disconnect the source (which kills it).
    readonly property string inhibitCmd: "kde-inhibit --power --screenSaver sleep infinity"

    preferredRepresentation: compactRepresentation
    Plasmoid.icon: "preferences-desktop-screensaver"

    toolTipMainText: i18n("Keep Awake")
    toolTipSubText: awake
        ? i18n("Active: the computer will not sleep or start the screensaver")
        : i18n("Inactive: normal power behavior")

    Plasmoid.status: awake ? PlasmaCore.Types.ActiveStatus : PlasmaCore.Types.PassiveStatus

    P5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        // Long-running command: no data arrives until it exits, so the source
        // stays connected (process alive). Disconnecting terminates it.
    }

    function toggle() {
        if (awake) {
            executable.disconnectSource(inhibitCmd)
            awake = false
        } else {
            executable.connectSource(inhibitCmd)
            awake = true
        }
    }

    compactRepresentation: MouseArea {
        id: compactRoot
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton
        onClicked: root.toggle()

        Layout.minimumWidth: Kirigami.Units.iconSizes.small
        Layout.minimumHeight: Kirigami.Units.iconSizes.small
        implicitWidth: Kirigami.Units.iconSizes.large
        implicitHeight: Kirigami.Units.iconSizes.large

        Kirigami.Icon {
            anchors.fill: parent
            source: "preferences-desktop-screensaver"
            active: compactRoot.containsMouse
            opacity: root.awake ? 1.0 : 0.45
        }
    }

    fullRepresentation: Item {
        Layout.minimumWidth: Kirigami.Units.gridUnit * 9
        Layout.minimumHeight: Kirigami.Units.gridUnit * 7

        ColumnLayout {
            anchors.centerIn: parent
            spacing: Kirigami.Units.largeSpacing

            Kirigami.Icon {
                Layout.alignment: Qt.AlignHCenter
                implicitWidth: Kirigami.Units.iconSizes.enormous
                implicitHeight: Kirigami.Units.iconSizes.enormous
                source: "preferences-desktop-screensaver"
                opacity: root.awake ? 1.0 : 0.45

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.toggle()
                }
            }
            Text {
                Layout.alignment: Qt.AlignHCenter
                color: Kirigami.Theme.textColor
                text: root.awake ? i18n("Active — the computer won't sleep")
                                 : i18n("Inactive — normal power")
            }
        }
    }

    Component.onDestruction: {
        if (awake) {
            executable.disconnectSource(inhibitCmd)
        }
    }
}
