/**
 * Playground.qml
 *
 * Copyright (C) 2017 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPL v2
 *
 * TODO: Description.
 */


import QtQuick 2.3
import Colours 1.0 as Colours


Item {
    id: root

    property int inputCount: 0

    signal requestPrompt()


    // --- Public Methods ---------------------------------------------------------------

    function run() {
        cxx_inputRunner.executeFinished.connect(_onExecuteFinished);
    }

    function stop() {
        cxx_inputRunner.executeFinished.disconnect(_onExecuteFinished);
    }

    // --- Public Slot Methods ----------------------------------------------------------

    function userInput(text) {
        if (cxx_inputRunner.checkInstruction(text)) {
            console.log("Step: userInput: User entered instruction, retry");
            // TODO: Add a small ~0.5s delay here.
            requestPrompt();
            return;
        }

        cxx_inputRunner.execute(text);
    }

    // --- Private Slot Methods ---------------------------------------------------------

    function _onExecuteFinished(successful) {
        if (successful) {
            console.log("Playground: _onExecuteFinished: Successful, step complete");
            completed();
        } else {
            console.log(
                "Playground: _onExecuteFinished: Script encountered error, requesting" +
                " user prompt"
            );
            var error = cxx_inputRunner.getError();
            if (error != "") {
                console.log(
                    "Playground: _onExecuteFinished: Error retrieved," +
                    " requesting error print"
                );
                requestPrintText(
                    "<font color='%1'>".arg(Colours.Palette.tallPoppy) + error + "</font>"
                );
            }
            requestPrompt();
        }
    }
}
