BOXES=( default centos-6-x64 )
for BOX in "${BOXES[@]}"; do
  PUPPET_INSTALL_TYPE="agent" BEAKER_set="${BOX}" bundle exec rake beaker
done
