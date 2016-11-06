#!/bin/sh
# the purpose of this program is to force the firmware build process into
# retaining the original file timestamps by bind mounting the 
# Linux 'cp' program and specifying the extra command arguments
CMD=$(/usr/bin/basename $0)
PROGRAM=cp
EXTRA_ARGS="-pv"
TOOLS="$HOME/blackfuel/asuswrt-merlin-tools"
TOOLS_ORIGINAL="$TOOLS/original"
TOOLS_ROOT="$TOOLS/root"
SELF="$TOOLS/${PROGRAM}"
TARGET="$(which $PROGRAM)"
TARGET_ORIGINAL="$TOOLS_ORIGINAL/$PROGRAM"
CMDLEVEL=0

case $CMD in
  "${PROGRAM}" )
    ATTACHED=0
    /bin/mount | /bin/grep -q $TARGET && ATTACHED=1
    case $1 in
      "attach" )
        if [ $ATTACHED -eq 0 ]; then
          mkdir -p $TOOLS_ORIGINAL
          $TOOLS_ROOT/bin/cp -p $TARGET $TARGET_ORIGINAL
          sudo /bin/mount -o bind $SELF $TARGET
        else
          /bin/echo "Already attached."
          exit 1
        fi
        ;;
      "detach" )
        if [ $ATTACHED -eq 1 ]; then
          sudo /bin/umount $TARGET
          rm -f $TARGET_ORIGINAL
        else
          /bin/echo "Not attached."
          exit 1
        fi
        ;;
      * )
        # all arguments
        CMDLEVEL=2
        ;;
    esac
    ;;
  * )
    # all other aliases
    CMDLEVEL=2
    ;;
esac

if [ $CMDLEVEL -gt 0 ]; then
  # now delegate to the base implementation
  $TARGET_ORIGINAL $EXTRA_ARGS $@
fi