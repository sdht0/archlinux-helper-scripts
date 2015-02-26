BASEDIR=/run/media/sdh/sdh-hdd3

rm -rf $BASEDIR/dev/archlinux-logs/a && \
mkdir -p $BASEDIR/dev/archlinux-logs/a && \
python $BASEDIR/dev/scripts/parseFrameworks.py && \
rm -rf $BASEDIR/dev/archlinux-logs/b && \
mkdir -p $BASEDIR/dev/archlinux-logs/b && \
python $BASEDIR/dev/scripts/parseWorkspace.py && \
rm -rf $BASEDIR/dev/archlinux-PKGBUILDs/kde5/* && \
cp -a $BASEDIR/dev/archlinux-logs/a/* $BASEDIR/dev/archlinux-logs/b/* $BASEDIR/dev/archlinux-PKGBUILDs/kde5 && \
cp -a $BASEDIR/dev/archlinux-logs/manual/* $BASEDIR/dev/archlinux-PKGBUILDs/kde5 && \
echo "done."