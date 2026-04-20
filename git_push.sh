#!/bin/bash

git_push(){
	read -p "To wich branch do you want push the commit ?" branch
	read -p "What is your commit message before pushing it to the Internet ?" message 

	if [ -z "$branch"] || [ -z "$message" ]; then

	  echo "No answer has been given, aborting the git push process ..."

	  exit 1

	else
	    git add .
	    git commit -m "$message"
	    git push origin "$branch"

	fi
}

git_push
