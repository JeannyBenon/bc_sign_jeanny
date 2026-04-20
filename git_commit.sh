#!/bin/bash

git_commit() {
    read -p "What is your commit message ? " message

    if [ -z "$message" ]; then
        echo "No answer has been given, aborting the git commit process …"
        exit 1
    else
        git add .
        git commit -m "$message"
        echo "Succès : Fichiers ajoutés et commit effectué."
    fi
}

git_commit
