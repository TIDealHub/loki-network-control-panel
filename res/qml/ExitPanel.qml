import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

import QClipboard 1.0
import "."

Container {
  property var address: ""
  property var authcode: ""
  property var status: ""
  property var busy: false
  property var hasExit: false
  property var exitSetByDaemon: false
  
    Layout.preferredHeight: 167
    Layout.preferredWidth: Style.appWidth

    contentItem: Rectangle {
        id: connectedStatusRect
        color: Style.panelBackgroundColor
    }

    Text {
        id: exitLabelText

        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20

        y: 3
        text: "Exit Node"
        font.family: Style.weakTextFont
        color: Style.weakTextColor
        font.pointSize: Style.weakTextSize
        font.capitalization: Font.AllUppercase
    }

    TextField {
        id: exitTextInput
        background: Rectangle{
          color: Style.textInputBackgroundColor
        }
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20

        y: 25
        text: address
        font.family: Style.weakTextFont
        color: Style.strongTextColor
        font.pointSize: Style.weakTextSize
    }

    Text {
        id: authLabelText

        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20

        y: 62
        text: "Auth Code"
        font.family: Style.weakTextFont
        color: Style.weakTextColor
        font.pointSize: Style.weakTextSize
        font.capitalization: Font.AllUppercase
    }

    TextField {
        id: authTextInput

        background: Rectangle{
          color: Style.textInputBackgroundColor
        }
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20

        y: 82
        text: authcode
        font.family: Style.weakTextFont
        color: Style.strongTextColor
        font.pointSize: Style.weakTextSize
        echoMode: TextInput.Password
    }

    Switch {
      id: exitButton
      // palette.dark: Style.lokiDarkGreen;
      text: hasExit > 0  ? "Exit On" : "Exit off"
      checkable: !busy
      checked: hasExit
      background: Rectangle{
        color: Style.panelBackgroundColor
        opacity: exitButton.checked ? 1 : 0.3
        border.color: Style.lokiDarkGreen
        border.width: exitButton.checked ? 2 : 0
        radius: 10
      }

      anchors.left: parent.left
      anchors.leftMargin: 20
      anchors.right: parent.right
      anchors.rightMargin: 20

      contentItem: Text{
        text: exitButton.text
        color: Style.lokiFontWhite
        font.family: Style.weakTextFont
        font.pointSize: Style.weakTextSize
        font.capitalization: Font.AllUppercase
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

      }

      y: 112
      onClicked: {
        if(busy)
        {
          return;
        }
        var exitAddr = exitTextInput.text;
        var exitAuth = authTextInput.text;
        console.log("hasExit="+hasExit+" checked="+checked);
        if(hasExit || !checked)
        {
          console.log("remove exit");
          apiClient.llarpDelExit(function(result, error) { });
          statusLabelText.text = "Exit Off";
          exitButton.text = "Enable Exit";
          statusLabelText.color = Style.weakTextColor;
          hasExit = false;
          checked = false;
          return;
        }
        statusLabelText.color = Style.weakTextColor;
        busy = true;
        apiClient.llarpAddExit(exitAddr, exitAuth, function(result, error) {
          console.log("add exit result", result, error);
          busy = false;
          if(error)
          {
            status = "Error: " +error;
            statusLabelText.color = Style.errorRed;
            checked = false;
            hasExit = false;
            return;
          }
          var j = JSON.parse(result);
          if(j.error)
          {
            status = "Error: " + j.error;
            checked = false;
            hasExit = false;
            statusLabelText.color = Style.errorRed;
            return;
          }
          if(j.result)
          {
            console.log("exit result: ",j.result);
            statusLabelText.color = Style.weakTextColor;
            statusLabelText.text = "Exit enabled";
            exitButton.text = "Disable Exit";
            hasExit = true;
            if(exitAuth.length > 0)
            {
              apiClient.llarpConfigSet("network", "exit-auth", exitAddr + ":" + exitAuth, function(error, result) {
                console.log(error, result);
              });
            }
            apiClient.llarpConfigSet("network", "exit-node", exitAddr, function(error, result) {
              console.log(error, result);
            });
            console.log("Save exit");
            checked = true;
          }
        });
      }
    }

    Text {
      id: statusLabelText
      anchors.left: parent.left
      anchors.leftMargin: 20
      anchors.right: parent.right
      anchors.rightMargin: 20
      y: 150
      text: status
      font.family: Style.weakTextFont
      color: Style.weakTextColor
      font.pointSize: Style.weakTextSize
      font.capitalization: Font.AllUppercase
    }

}
