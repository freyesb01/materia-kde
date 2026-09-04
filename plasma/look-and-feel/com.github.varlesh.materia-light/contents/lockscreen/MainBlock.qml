
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3 as PC3 as PlasmaComponents

import "../components"

SessionManagementScreen {

    property Item mainPasswordBox: passwordBox
    property bool lockScreenUiVisible: false
    property alias echoMode: passwordBox.echoMode

    property int visibleBoundary: mapFromItem(loginButton, 0, 0).y
    onHeightChanged: visibleBoundary = mapFromItem(loginButton, 0, 0).y + loginButton.height + units.smallSpacing

    signal passwordResult(string password)

    function startLogin() {
        var password = passwordBox.text

        loginButton.forceActiveFocus();
        passwordResult(password);
    }

    RowLayout {
        Layout.fillWidth: true

        PC3.TextField {
            id: passwordBox
            font.pointSize: theme.defaultFont.pointSize + 1
            Layout.fillWidth: true

            placeholderText: i18nd("plasma_lookandfeel_org.kde.lookandfeel",
                                   "Password")
            focus: true
            echoMode: TextInput.Password
            inputMethodHints: Qt.ImhHiddenText | Qt.ImhSensitiveData
                              | Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
            enabled: !authenticator.graceLocked
            revealPasswordButtonShown: true

            onAccepted: {
                if (lockScreenUiVisible) {
                    startLogin();
                }
            }

            Keys.onPressed: {
                if (event.key === Qt.Key_Left && !text) {
                    userList.decrementCurrentIndex();
                    event.accepted = true
                }
                if (event.key === Qt.Key_Right && !text) {
                    userList.incrementCurrentIndex();
                    event.accepted = true
                }
            }

            Connections {
                target: root
                function onClearPassword() {
                    passwordBox.forceActiveFocus()
                    passwordBox.text = "";
                }
            }
        }

        PC3.Button {
            id: loginButton
            Accessible.name: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Unlock")
            implicitHeight: passwordBox.height
            implicitWidth: loginButton.implicitHeight
            iconSource: "go-next"
      
            onClicked: startLogin()
            Keys.onEnterPressed: clicked()
            Keys.onReturnPressed: clicked()
        }

        PC3.Button {
            id: switchButton
            Accessible.name: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Switch User")
            implicitHeight: passwordBox.height
            implicitWidth: switchButton.implicitHeight
            iconSource: "system-switch-user"
            
            onClicked: {
                if (((sessionsModel.showNewSessionEntry
                      && sessionsModel.count === 1)
                     || (!sessionsModel.showNewSessionEntry
                         && sessionsModel.count === 0))
                        && sessionsModel.canSwitchUser) {
                    mainStack.pop({
                                      "immediate": true
                                  })
                    sessionsModel.startNewSession(true /* lock the screen too */
                                                  )
                    lockScreenRoot.state = ''
                } else {
                    mainStack.push(switchSessionPage)
                }
            }
        }
    }
}
