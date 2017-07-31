#!/bin/bash
gsettings set com.canonical.Unity.Lenses disabled-scopes "['more_suggestions-amazon.scope', 'more_suggestions-u1ms.scope', 'more_suggestions-populartracks.scope', 'music-musicstore.scope', 'more_suggestions-ebay.scope', 'more_suggestions-ubuntushop.scope', 'more_suggestions-skimlinks.scope']"
for USER in `ls -1 /home`; do
  if [ ! ${USER} == "lost+found" ]
  then
    chown -R ${USER}:${USER} /home/${USER}
  fi
done
exit 0
