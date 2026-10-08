import QtQuick 
import QtQuick.Controls 
import QtMultimedia 

Rectangle { 
    id: container 
    anchors.fill: parent 
    color: "#222222" 

    property bool showSession: false 

    MediaPlayer { 
        id: player 
        source: "immutable.mp3" 
        loops: MediaPlayer.Infinite 
        audioOutput: AudioOutput { 
            id: audioOutput 
            volume: 0.5 
        } 
    } 

    Component.onCompleted: { 
        player.play() 
    } 

    Image { 
        id: bgImage 
        source: "background.jpg" 
        anchors.fill: parent 
        fillMode: Image.PreserveAspectCrop 
    } 

    Item { 
        id: frameContainer 
        width: 460 
        height: 500  
        anchors.centerIn: parent 

        Rectangle { 
            id: blinker1 
            height: 2; width: 25; color: "#ffffff" 
            anchors.top: parent.top 
            anchors.left: parent.left 
            anchors.leftMargin: 33 // 25 + 8 
            SequentialAnimation on opacity { 
                loops: Animation.Infinite 
                NumberAnimation { to: 0.0; duration: 600; easing.type: Easing.InOutSine } 
                NumberAnimation { to: 1.0; duration: 600; easing.type: Easing.InOutSine } 
                PauseAnimation { duration: 1200 } 
            } 
        } 
         
        Rectangle { 
            id: blinker2 
            height: 2; width: 25; color: "#ffffff" 
            anchors.top: parent.top 
            anchors.left: blinker1.right 
            anchors.leftMargin: 8 
            SequentialAnimation on opacity { 
                loops: Animation.Infinite 
                PauseAnimation { duration: 1200 } 
                NumberAnimation { to: 0.1; duration: 600; easing.type: Easing.InOutSine } 
                NumberAnimation { to: 1.0; duration: 600; easing.type: Easing.InOutSine } 
            } 
        } 

        Canvas { 
            id: borderCanvas 
            anchors.fill: parent 

            property real drawProgress: 0.0 
            onDrawProgressChanged: requestPaint() 

            readonly property real totalPathLength: 1846 

            onPaint: { 
                var ctx = getContext("2d"); 
                ctx.reset(); 

                ctx.strokeStyle = "#ffffff"; 
                ctx.lineWidth = 2; 

                ctx.beginPath(); 
                ctx.moveTo(99, 1); 
                ctx.lineTo(459, 1); 
                ctx.lineTo(459, 499); 
                ctx.lineTo(1, 499); 
                ctx.lineTo(1, 1); 
                ctx.lineTo(25, 1); 

                ctx.setLineDash([totalPathLength]); 
                ctx.lineDashOffset = totalPathLength * (1.0 - drawProgress); 

                ctx.stroke(); 
            } 
        } 

        Text { 
            id: starsText 
            text: "✱   ✱   ✱   ✱   ✱" 
            color: "#ffffff" 
            font.pixelSize: 22 
            font.bold: true 
            opacity: 0  
            anchors.top: parent.top 
            anchors.topMargin: 22 
            anchors.horizontalCenter: parent.horizontalCenter 
        } 

        Rectangle { 
            id: innerSeparator  
            width: 0  
            height: 1 
            color: "#ffffff" 
            opacity: 0.8 
            anchors.top: parent.top 
            anchors.topMargin: 75 
            anchors.left: parent.left  
            anchors.leftMargin: 20  
        } 

        Item { 
            id: loginBlock 
            width: parent.width - 60 
            height: 50 
            opacity: 0 
            anchors.top: parent.top 
            anchors.topMargin: 155 
            anchors.horizontalCenter: parent.horizontalCenter 

            transform: Translate {
                id: loginTrans
                x: -20
            }

            Text { 
                text: "USERNAME :" 
                color: "#ffffff" 
                font.pixelSize: 15 
                font.bold: true 
                font.letterSpacing: 1 
                anchors.left: parent.left 
                anchors.verticalCenter: parent.verticalCenter 
            } 

            TextField { 
                id: txtUsername 
                width: 235; height: 45 
                color: "transparent" 
                selectionColor: "transparent" 
                selectedTextColor: "transparent" 
                cursorDelegate: Item {} 
                font.family: "Oswald, Roboto Condensed, Trebuchet MS, sans-serif" 
                font.pixelSize: 32 
                font.italic: true 
                verticalAlignment: Text.AlignBottom 
                topPadding: 0 
                bottomPadding: 2 
                leftPadding: 0 
                rightPadding: 5 
                 
                text: typeof userModel !== "undefined" ? userModel.lastUser : "" 

                anchors.right: parent.right 
                anchors.verticalCenter: parent.verticalCenter 
                background: Rectangle { height: 1; color: "#ffffff"; anchors.bottom: parent.bottom } 
                focus: true 
                 
                KeyNavigation.tab: txtPassword 
                KeyNavigation.down: txtPassword 

                Text { 
                    id: userOverlayText 
                    anchors.fill: parent 
                    topPadding: 0 
                    bottomPadding: 2 
                    leftPadding: 0 
                    rightPadding: 5 
                    verticalAlignment: Text.AlignBottom 
                    color: "#ffffff" 
                    font.family: "Oswald, Roboto Condensed, Trebuchet MS, sans-serif" 
                    font.pixelSize: 32 
                    font.italic: true 
                    clip: true 
                    elide: Text.ElideNone 

                    property bool cursorBlink: true 

                    Timer { 
                        interval: 500 
                        running: txtUsername.activeFocus 
                        repeat: true 
                        onTriggered: userOverlayText.cursorBlink = !userOverlayText.cursorBlink 
                        onRunningChanged: if (!running) userOverlayText.cursorBlink = false 
                    } 

                    text: { 
                        var raw = txtUsername.text.replace(/`/g, "'"); 
                        var pos = txtUsername.cursorPosition;
                        var cursorChar = (txtUsername.activeFocus && userOverlayText.cursorBlink) ? "|" : ""; 
                        return raw.substring(0, pos) + cursorChar + raw.substring(pos); 
                    } 
                } 
            } 
        } 

        Item { 
            id: passBlock 
            width: parent.width - 60 
            height: 60 
            opacity: 0  
            anchors.top: parent.top 
            anchors.topMargin: 235 
            anchors.horizontalCenter: parent.horizontalCenter 

            transform: Translate {
                id: passTrans
                x: -20
            }

            Column { 
                anchors.left: parent.left 
                anchors.verticalCenter: parent.verticalCenter 
                spacing: 2 
                Text { text: "PASSWORD :"; color: "#ffffff"; font.pixelSize: 15; font.bold: true; font.letterSpacing: 1 } 
                 
                Text {  
                    text: "forgot your password?"  
                    color: "#ffffff"  
                    font.pixelSize: 11  
                    opacity: mouseForgot.containsMouse ? 1.0 : 0.6  
                    font.italic: true  

                    MouseArea { 
                        id: mouseForgot 
                        anchors.fill: parent 
                        hoverEnabled: true 
                        cursorShape: Qt.PointingHandCursor 
                        onClicked: container.showSession = !container.showSession 
                    } 
                } 
            } 

            TextField { 
                id: txtPassword 
                width: 235; height: 45 
                font.pixelSize: 22 
                font.italic: true 
                clip: true  
                 
                color: "transparent" 
                selectionColor: "transparent" 
                selectedTextColor: "transparent" 
                echoMode: TextInput.Password 
                cursorDelegate: Item {} 

                anchors.right: parent.right 
                anchors.verticalCenter: parent.verticalCenter 
                background: Rectangle { height: 1; color: "#ffffff"; anchors.bottom: parent.bottom } 
                 
                KeyNavigation.tab: sessionBox 
                KeyNavigation.up: txtUsername 
                KeyNavigation.down: sessionBox 

                onAccepted: { 
                    if (typeof sddm !== "undefined") 
                        sddm.login(txtUsername.text, txtPassword.text, sessionBox.currentIndex) 
                } 

                property int prevLength: 0 
                property bool showPreview: false 
                property bool isGlitching: false 
                property string currentGlitchChar: "" 
                 
                property string fakeString: "Terra" 
                property string glitchChars: "#$%&!?@~№0123456789§±µ" 

                Timer { 
                    id: glitchTimer 
                    interval: 60  
                    repeat: false 
                    onTriggered: txtPassword.isGlitching = false 
                } 

                Timer { 
                    id: previewTimer 
                    interval: 1000 
                    repeat: false 
                    onTriggered: txtPassword.showPreview = false 
                } 

                onTextChanged: { 
                    var currentLen = text.length; 
                     
                    if (currentLen > prevLength) { 
                        if (currentLen <= 5) { 
                            showPreview = true; 
                            isGlitching = true; 
                             
                            var randomIndex = Math.floor(Math.random() * glitchChars.length); 
                            currentGlitchChar = glitchChars.charAt(randomIndex); 
                             
                            glitchTimer.restart(); 
                            previewTimer.restart(); 
                        } else { 
                            showPreview = false; 
                            isGlitching = false; 
                            glitchTimer.stop(); 
                            previewTimer.stop(); 
                        } 
                    } else { 
                        showPreview = false; 
                        isGlitching = false; 
                        glitchTimer.stop(); 
                        previewTimer.stop(); 
                    } 
                     
                    prevLength = currentLen; 
                } 

                Text { 
                    id: passOverlayText 
                    anchors.fill: parent 
                    topPadding: 0 
                    bottomPadding: 2 
                    leftPadding: 0 
                    rightPadding: 5 
                    verticalAlignment: Text.AlignBottom 
                    color: "#ffffff" 
                    font.family: "Oswald, Roboto Condensed, Trebuchet MS, sans-serif" 
                    font.pixelSize: 22 
                    font.bold: true 
                    font.italic: true 
                    font.letterSpacing: 1 
                    clip: true 
                    elide: Text.ElideNone 

                    property bool cursorBlink: true 

                    Timer { 
                        interval: 500 
                        running: txtPassword.activeFocus 
                        repeat: true 
                        onTriggered: passOverlayText.cursorBlink = !passOverlayText.cursorBlink 
                        onRunningChanged: if (!running) passOverlayText.cursorBlink = false 
                    } 

                    text: { 
                        var len = txtPassword.text.length; 
                        var pos = txtPassword.cursorPosition;
                        var cursorChar = (txtPassword.activeFocus && passOverlayText.cursorBlink) ? "|" : ""; 
                         
                        if (len === 0) return cursorChar; 
                         
                        var dotChar = "✱";  
                        var mainText = ""; 
                         
                        if (txtPassword.showPreview && len > 0) { 
                            var dots = ""; 
                            for (var i = 0; i < len - 1; i++) { 
                                dots += dotChar; 
                            } 
                             
                            var displayChar = txtPassword.isGlitching ?  
                                txtPassword.currentGlitchChar :  
                                txtPassword.fakeString.charAt(len - 1); 
                                 
                            mainText = dots + displayChar; 
                        } else { 
                            var allDots = ""; 
                            for (var j = 0; j < len; j++) { 
                                allDots += dotChar; 
                            } 
                            mainText = allDots; 
                        } 

                        return mainText.substring(0, pos) + cursorChar + mainText.substring(pos); 
                    } 
                } 
            } 
        } 

        Item { 
            id: sessionBlock 
            width: parent.width - 60 
            height: 50 
            anchors.top: parent.top 
            anchors.topMargin: 310 
            anchors.horizontalCenter: parent.horizontalCenter 
             
            visible: container.showSession 
            opacity: container.showSession ? 1.0 : 0.0 
            Behavior on opacity { NumberAnimation { duration: 200 } } 

            Text { 
                text: "SESSION :" 
                color: "#ffffff" 
                font.pixelSize: 15 
                font.bold: true 
                font.letterSpacing: 1 
                anchors.left: parent.left 
                anchors.verticalCenter: parent.verticalCenter 
            } 

            ComboBox { 
                id: sessionBox 
                width: 235; height: 35 
                anchors.right: parent.right 
                anchors.verticalCenter: parent.verticalCenter 
                model: typeof sessionModel !== "undefined" ? sessionModel : null 
                textRole: "name" 

                currentIndex: (typeof sessionModel !== "undefined" && sessionModel.lastIndex >= 0) ? sessionModel.lastIndex : 0 

                KeyNavigation.up: txtPassword 

                contentItem: Text { 
                    text: sessionBox.displayText 
                    font.pixelSize: 14 
                    font.bold: true 
                    color: "#ffffff" 
                    verticalAlignment: Text.AlignVCenter 
                    horizontalAlignment: Text.AlignLeft 
                    leftPadding: 5 
                } 
                background: Rectangle { 
                    color: "transparent" 
                    border.color: "#ffffff" 
                    border.width: 1 
                } 
            } 
        } 

        Item { 
            id: extraActionBlock 
            width: parent.width - 60 
            height: 40 
            anchors.top: parent.top 
            anchors.topMargin: 370 
            anchors.horizontalCenter: parent.horizontalCenter 

            visible: container.showSession 
            opacity: container.showSession ? 1.0 : 0.0 
            Behavior on opacity { NumberAnimation { duration: 200 } } 

            property var messages: [ 
                "PRESS ENTER TO LOGIN", 
                "WHO YOU?", 
                "WELCOME BACK, ADMINISTRATOR", 
                "ESTABLISHING CONNECTION...", 
                "System Malfunction", 
                "Secure Session?", 
                "Hidden Settings Detected",
		"Step by Step by Stepping` Stone"
		
            ] 

            property string randomText: { 
                if (container.showSession) { 
                    var index = Math.floor(Math.random() * messages.length); 
                    return messages[index]; 
                } 
                return messages[0]; 
            } 

            Text { 
                id: actionText 
                text: extraActionBlock.randomText 
                color: "#ffffff" 
                font.pixelSize: 12 
                font.letterSpacing: 1 
                opacity: mouseAction.containsMouse ? 1.0 : 0.7 
                anchors.centerIn: parent 
                font.italic: true 

                MouseArea { 
                    id: mouseAction 
                    anchors.fill: parent 
                    hoverEnabled: true 
                    cursorShape: Qt.PointingHandCursor 
                    onClicked: { 
                        if (typeof sddm !== "undefined") 
                            sddm.login(txtUsername.text, txtPassword.text, sessionBox.currentIndex) 
                    } 
                } 
            } 
        } 
         
        ParallelAnimation { 
            running: true 

            NumberAnimation {  
                target: borderCanvas; property: "drawProgress" 
                from: 0.0; to: 1.0 
                duration: 2200; easing.type: Easing.InOutQuad 
            } 

            SequentialAnimation { 
                PauseAnimation { duration: 600 } 
                ParallelAnimation { 
                    NumberAnimation { target: starsText; property: "opacity"; from: 0; to: 1.0; duration: 400 } 
                    NumberAnimation { target: innerSeparator; property: "width"; from: 0; to: 420; duration: 800; easing.type: Easing.OutQuad } 
                } 
            } 

            SequentialAnimation { 
                PauseAnimation { duration: 1100 } 
                ParallelAnimation { 
                    NumberAnimation { target: loginBlock; property: "opacity"; from: 0; to: 1.0; duration: 600 } 
                    NumberAnimation { target: loginTrans; property: "x"; from: -20; to: 0; duration: 600; easing.type: Easing.OutQuart } 
                } 
            } 

            SequentialAnimation { 
                PauseAnimation { duration: 1400 } 
                ParallelAnimation { 
                    NumberAnimation { target: passBlock; property: "opacity"; from: 0; to: 1.0; duration: 600 } 
                    NumberAnimation { target: passTrans; property: "x"; from: -20; to: 0; duration: 600; easing.type: Easing.OutQuart } 
                } 
            } 
        } 
    } 
}