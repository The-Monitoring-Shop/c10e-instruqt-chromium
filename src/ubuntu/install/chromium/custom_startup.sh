#!/usr/bin/env bash
set -ex
START_COMMAND="chromium-browser"
PGREP="chromium"
MAXIMIZE="true"
DEFAULT_ARGS=""

if [[ $MAXIMIZE == 'true' ]] ; then
    DEFAULT_ARGS+=" --start-maximized"
fi
ARGS=${APP_ARGS:-$DEFAULT_ARGS}


###############################################################################
###############################################################################
# Chronosphere modification
###############################################################################
###############################################################################
DEFAULT_LOAD=0
LOAD_EXTENSIONS=""
DEFAULT_USER="No username found"

# To allow tenant user/password to be passed as ENV variable and enable autoLogin extension
if [[ ${AUTOLOGIN:-$DEFAULT_LOAD} -eq 1 ]]; then
    MY_EMAIL=${AUTOLOGIN_EMAIL:-$DEFAULT_USER}
    MY_PASSWORD=${AUTOLOGIN_PASSWORD:-$DEFAULT_USER}
    sed -i "s/{{AUTOLOGIN_EMAIL}}/${MY_EMAIL}/g" /home/kasm-user/extensions/c10e-autoLogin/autoLogin.js
    sed -i "s/{{AUTOLOGIN_PASSWORD}}/${MY_PASSWORD}/g" /home/kasm-user/extensions/c10e-autoLogin/autoLogin.js
    
    [[ -z ${LOAD_EXTENSIONS} ]] && LOAD_EXTENSIONS="/home/kasm-user/extensions/c10e-autoLogin" || LOAD_EXTENSIONS+=",/home/kasm-user/extensions/c10e-autoLogin"
fi

# To enable removeNavMenuAdmin extension
if [[ ${REMOVEADMINMENU:-$DEFAULT_LOAD} -eq 1 ]]; then
    [[ -z ${LOAD_EXTENSIONS} ]] && LOAD_EXTENSIONS="/home/kasm-user/extensions/c10e-removeNavMenuAdmin"  || LOAD_EXTENSIONS+=",/home/kasm-user/extensions/c10e-removeNavMenuAdmin"
fi

# To set chromium --load-extension parameter
if [[ -n ${LOAD_EXTENSIONS} ]]; then
    ARGS+=" --load-extension=${LOAD_EXTENSIONS}"
fi
###############################################################################
###############################################################################


options=$(getopt -o gau: -l go,assign,url: -n "$0" -- "$@") || exit
eval set -- "$options"

while [[ $1 != -- ]]; do
    case $1 in
        -g|--go) GO='true'; shift 1;;
        -a|--assign) ASSIGN='true'; shift 1;;
        -u|--url) OPT_URL=$2; shift 2;;
        *) echo "bad option: $1" >&2; exit 1;;
    esac
done
shift

# Process non-option arguments.
for arg; do
    echo "arg! $arg"
done

FORCE=$2

kasm_exec() {
    if [ -n "$OPT_URL" ] ; then
        URL=$OPT_URL
    elif [ -n "$1" ] ; then
        URL=$1
    fi 
    
    # Since we are execing into a container that already has the browser running from startup, 
    #  when we don't have a URL to open we want to do nothing. Otherwise a second browser instance would open. 
    if [ -n "$URL" ] ; then
        /usr/bin/filter_ready
        /usr/bin/desktop_ready
        $START_COMMAND $ARGS $OPT_URL
    else
        echo "No URL specified for exec command. Doing nothing."
    fi
}

kasm_startup() {
    if [ -n "$KASM_URL" ] ; then
        URL=$KASM_URL
    elif [ -z "$URL" ] ; then
        URL=$LAUNCH_URL
    fi

    if [ -z "$DISABLE_CUSTOM_STARTUP" ] ||  [ -n "$FORCE" ] ; then

        echo "Entering process startup loop"
        set +x
        while true
        do
            if ! pgrep -x $PGREP > /dev/null
            then
                /usr/bin/filter_ready
                /usr/bin/desktop_ready
                set +e
                $START_COMMAND $ARGS $URL
                set -e
            fi
            sleep 1
        done
        set -x
    
    fi

} 

if [ -n "$GO" ] || [ -n "$ASSIGN" ] ; then
    kasm_exec
else
    kasm_startup
fi
