#!/bin/sh
 
### DO NOT EDIT OR OVERLAY THIS FILE
# These definitions are here to define the functions.
# You can overlay the grouperScriptHooks.sh file with any definitions of these functions
 
 
# called after the setupFiles functions is called, almost before the process starts
grouperScriptHooks_setupFilesPost() {
  echo "trainingContainer; INFO: (grouperScriptHooks.sh-grouperScriptHooks_setupFilesPost) starting..."
  sed -i "s|Rewrite|#Rewrite|g" /etc/httpd/conf.d/ssl-enabled.conf
  echo "trainingContainer; INFO: (grouperScriptHooks.sh-grouperScriptHooks_setupFilesPost) sed -i 's|Rewrite|#Rewrite|g' /etc/httpd/conf.d/ssl-enabled.conf , result=$?"
}

export -f grouperScriptHooks_setupFilesPost

echo "trainingContainer; INFO: (grouperScriptHooks.sh-body) export -f grouperScriptHooks_setupFilesPost, result=$?"
 
