#!/bin/bash

PATH_TO_FILE="$(cd `dirname $0` && pwd)";

declare -A projects

# A list of projects I have follow.
# This is Bash way to have a key value pair. 
# The key will be set at the project name, the value as the upstream remote

projects["git"]="git@github.com:git/git.git"
projects["rails"]="git@github.com:rails/rails.git"
projects["ruby"]="git@github.com:ruby/ruby.git" 
projects["docker"]="git@github.com:docker/docker.git"


for project in ${!projects[@]}; do
  cd ${PATH_TO_FILE}
  echo ${project} ${projects[${project}]}

  if [[ ! -d ${PATH_TO_FILE}/${project} ]]; then 
    git clone git@github.com:OpenSourceProjects/${project}.git ${project}

    # Append to .gitignore if first time
    if [[ `grep ${project} ${PATH_TO_FILE}/.gitignore | wc -l | awk '{print $1}'` -lt 1 ]]; then
      echo "${project}" >> ${PATH_TO_FILE}/.gitignore
    fi

    cd ${project}
    git remote add upstream ${projects[$project]}
    git remote update
    BRANCH=`git branch | cut -d " " -f 2`

    echo $BRANCH
    # Set master to track upstream
    git config branch.${BRANCH}.remote upstream
    git config branch.${BRANCH}.merge refs/heads/${BRANCH}
  else
    cd ${PATH_TO_FILE}/${project}
    git pull
  fi
done
