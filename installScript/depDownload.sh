#!/bin/bash
################################################################################

# mw@Acc: Modified, we dont want any sources modification on our server 
# Check if dependency is satisfied
function check_package() {

  which parallel >/dev/null 2>&1 || {
    BASHERRCODE=1
    echo "parallel , is missing"
    return 1
  }
  which wget >/dev/null 2>&1 || {
    echo "wget , is missing"
    BASHERRCODE=1
    return 1
  }
  which curl >/dev/null 2>&1 || {
    echo "curl , is missing"
    BASHERRCODE=1
    return 1
  }
  which sqlite3  >/dev/null 2>&1 || {
    echo "sqlite3 , is missing"
    BASHERRCODE=1
    return 1
  }
  return 0
}

################################################################################
# install_ubuntu: Install all the dependencies in Ubuntu Server
################################################################################
function install_ubuntu() {
  echo "Check dependencies (deb)."
  check_package
  #apt update > /dev/null 2>&1
  #apt install -y parallel > /dev/null 2>&1


  $BASHERRCODE -eq "$?"
  if [[ $BASHERRCODE -eq 0 ]]; then
    echo "Dependencies are satisfied."
  else
    echo "Your server is missing some dependencies."
    echo "Try manual execute the command:"
    echo "apt update && apt install parallel wget curl sqlite3"
    exit "$ERR_DEPNOTFOUND"
  fi
}

################################################################################
# install_redhat: Install all the dependencies in Red Hat and CentOS
################################################################################
function install_redhat() {
  echo "Check dependencies (rpm)."
  check_package
  # grep 6 /etc/redhat-release > /dev/null 2>&1
  BASHERRCODE=$?
  
  #if [[ $BASHERRCODE -eq 0 ]]; then
  #  wget -O "/etc/yum.repos.d/tange.repo" "$OLE_TANGE" > /dev/null 2>&1
  #  BASHERRCODE=$?
  #  if [[ $BASHERRCODE -ne 0 ]]; then
  #    echo "Failure - Can't install Tange's repository for Parallel"
  #    exit "$ERR_NO_CONNECTION"
  #  fi
  #fi
  #yum install -y epel-release  > /dev/null 2>&1
  #yum install -y parallel  > /dev/null 2>&1
  #BASHERRCODE=$?
  if [[ $BASHERRCODE -eq 0 ]]; then
    echo "Dependencies are satisfied."
  else
    echo "Your server is missing some dependencies."
    echo "Try manual execute the command:"
    echo "yum install epel-release"
    echo "yum install parallel wget curl sqlite3"
    exit "$ERR_DEPNOTFOUND"
  fi
}
# mw@Acc: Modified, end.

################################################################################
# remove_ubuntu: Remove all the dependencies in Ubuntu Server
################################################################################
function remove_ubuntu() {
  # mw@acc: <
  echo "we dont want any automatic package remove, on our server"
  return 0
  # mw@acc: >

  echo "Removing dependencies. Please wait..."
  apt --purge remove -y parallel > /dev/null 2>&1
  BASHERRCODE=$?
  if [[ $BASHERRCODE -eq 0 ]]; then
    echo "Dependencies removed with success!"
  else
    echo "Dependencies wasn't removed in your server"
    echo "Please check if you have connection with the internet and apt is"
    echo "working and try again."
    echo "Or you can try manual execute the command:"
    echo "apt remove -y parallel"
  fi
}

################################################################################
# remove_redhat: Install all the dependencies in Red Hat and CentOS
################################################################################
function remove_redhat() {
  # < mw@acc: 
  echo "we dont want any automatic package remove, on our server"
  return 0
  # mw@acc: >

  echo "Removing dependencies. Please wait..."
  grep 6 /etc/redhat-release > /dev/null 2>&1
  BASHERRCODE=$?
  if [[ $BASHERRCODE -eq 0 ]]; then
    pip uninstall -y curl > /dev/null 2>&1
  fi
  yum remove -y parallel > /dev/null 2>&1
  BASHERRCODE=$?
  if [[ $BASHERRCODE -eq 0 ]]; then
    echo "Dependencies removed with success!"
  else
    echo "Dependencies wasn't removed in your server"
    echo "Please check if you have connection with the internet and yum is"
    echo "working and try again."
    echo "Or you can try manual execute the command:"
    echo "yum install -y epel-release && yum install -y parallel"
  fi
}
