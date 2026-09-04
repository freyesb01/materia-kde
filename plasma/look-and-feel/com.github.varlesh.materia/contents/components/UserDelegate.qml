import QtQuick
import QtGraphicalEffects 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3 as PC3 as PlasmaComponents

Item {
    id: wrapper


    property bool isCurrent: true

    readonly property var m: model
    property string name
    property string userName
    property string avatarPath
    property string iconSource
    property bool constrainText: true
    property alias nameFontSize: usernameDelegate.font.pointSize
    signal clicked()

    property real faceSize: units.gridUnit * 7

    opacity: isCurrent ? 1.0 : 0.5

    Behavior on opacity {
        OpacityAnimator {
            duration: units.longDuration
        }
    }

    Item {
        id: imageSource
        anchors {
            bottom: usernameDelegate.top
            bottomMargin: units.largeSpacing
            horizontalCenter: parent.horizontalCenter
        }
        Behavior on width { 
            PropertyAnimation {
                from: faceSize
                duration: units.longDuration * 2;
            }
        }
        width: isCurrent ? faceSize : faceSize - units.largeSpacing
        height: width

        Image {
            id: face
            source: wrapper.avatarPath
            sourceSize: Qt.size(faceSize, faceSize)
            fillMode: Image.PreserveAspectCrop
            anchors.fill: parent
            property bool rounded: true
            property bool adapt: true
            layer.enabled: rounded
            layer.effect: OpacityMask {
                maskSource: Item {
                    width: face.width
                    height: face.height
                    Rectangle {
                        anchors.centerIn: parent
                        width: face.adapt ? face.width : Math.min(face.width, face.height)
                        height: face.adapt ? face.height : width
                        radius: Math.min(width, height)   
                    }
                } 
            }  
        }

        PlasmaCore.IconItem {
            id: faceIcon
            source: iconSource
            visible: (face.status == Image.Error || face.status == Image.Null)
            anchors.fill: parent
            anchors.margins: units.gridUnit * 0.5 // because mockup says so...
            colorGroup: PlasmaCore.ColorScope.colorGroup
        }
    }

    PC3.Label {
        id: usernameDelegate
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
        height: implicitHeight // work around stupid bug in Plasma Components that sets the height
        width: constrainText ? parent.width : implicitWidth
        text: wrapper.name
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
        font.underline: wrapper.activeFocus
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onClicked: wrapper.clicked();
    }

    Accessible.name: name
    Accessible.role: Accessible.Button
    function accessiblePressAction() { wrapper.clicked() }
}
