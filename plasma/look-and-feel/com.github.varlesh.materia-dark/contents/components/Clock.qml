import QtQuick
import QtQuick.Layouts

import org.kde.plasma.core 2.0
import org.kde.plasma.components 3 as PC3

ColumnLayout {
    Label {
        text: Qt.formatTime(timeSource.data["Local"]["DateTime"])
        font.pointSize: 44
        font.weight: Font.Light
        Layout.alignment: Qt.AlignHCenter
        renderType: Text.QtRendering
    }
    Label {
        text: Qt.formatDate(timeSource.data["Local"]["DateTime"], Qt.DefaultLocaleLongDate)
        font.pointSize: 20
        font.weight: Font.Light
        Layout.alignment: Qt.AlignHCenter
    }
    DataSource {
        id: timeSource
        engine: "time"
        connectedSources: ["Local"]
        interval: 1000
    }
}
