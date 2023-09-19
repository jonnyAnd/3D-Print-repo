#!/bin/bash

### USB Vars
PATH_TO_SYSTEM_MEDIA_FOLDER="/media"
PRINTER_USB_NAME="3DPRINTER"
USER_NAME=""
PATH_TO_PRINTER_USB=""
PRINTER_USB_INSERTED=false
PRINT_FOLDER_NAME="TO_PRINT"


initialise(){     

    setPrinterUSB
    showUserPrompt
    getUserCommand

}

getUserCommand(){
    read -p "Do what?:" USER_COMMAND

    if [[ "$USER_COMMAND" == "1" ]]; then
        pushAll
    elif [[ "$USER_COMMAND" == "2" ]]; then
        nothing_yet
    elif [[ "$USER_COMMAND" == "3" ]]; then
        nothing_yet
    elif [[ "$USER_COMMAND" == "4" ]]; then
        syncUSBPrintFolder
    elif [[ "$USER_COMMAND" == "q" ]]; then
        exit
    else
        echo "$USER_COMMAND - Not valid command"
        showUserPrompt
        getUserCommand
    fi
}


showUserPrompt(){
    clear
    echo "This is a user prompt"
    echo "1 - Push All to GitHub "
    echo "2 - nothing yet "
    echo "3 - nothing yet "

    ## USB COMMANDS
    if [ "$PRINTER_USB_INSERTED" = true ] ; then
        echo "4 - Sync USB Print folder (will overwrite USB Content)"
    fi

    echo "q - exit "

    echo ' '
}

pushAll(){
    git add .
    git commit -m "Automated sync with local"
    git push origin main
}

nothing_yet(){
    echo "Nothing yet"
}

syncUSBPrintFolder(){
    if [ "$PRINTER_USB_INSERTED" = true ] ; then
        if [ -d "$PATH_TO_PRINT_FOLER_PATH" ] 
        then
            rm -rf $PATH_TO_PRINT_FOLER_PATH
        fi 

        mkdir $PATH_TO_PRINT_FOLER_PATH

        cp -a "./$PRINT_FOLDER_NAME/." "$PATH_TO_PRINT_FOLER_PATH/"
    else
        echo "No USB found at - $PATH_TO_PRINTER_USB"
    fi
}

setPrinterUSB(){
    echo "Setting Printer USB"

    USER_NAME=$(whoami)
    PATH_TO_PRINTER_USB="$PATH_TO_SYSTEM_MEDIA_FOLDER/$USER_NAME/$PRINTER_USB_NAME"
    PATH_TO_PRINT_FOLER_PATH="$PATH_TO_PRINTER_USB/$PRINT_FOLDER_NAME"

    if [ -d "$PATH_TO_PRINTER_USB" ] 
    then
        echo "Printer USB found"
        PRINTER_USB_INSERTED=true
    else
        echo "Printer USB NOT found"

    fi
}

## --------------------------------------------

gotToProjectRoot(){
    cd $PROJECT_ROOT_LOCATION
}

setWorkingDirToScriptLocation(){
    cd "$(dirname "$0")"
    PROJECT_ROOT_LOCATION=$(pwd)
}

## --- Startup ---
PROJECT_ROOT_LOCATION=""
setWorkingDirToScriptLocation
initialise $@
