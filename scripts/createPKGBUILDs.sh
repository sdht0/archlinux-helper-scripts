BASEDIR=/run/media/sdh/sdh-hdd3

rm -rf $BASEDIR/dev/archlinux-extra/packages && \
mkdir -p $BASEDIR/dev/archlinux-extra/packages && \
python $BASEDIR/dev/scripts/parseFrameworks.py && \
python $BASEDIR/dev/scripts/parseWorkspace.py && \
rm -rf $BASEDIR/dev/archlinux-PKGBUILDs/kde5/* && \
cp -a $BASEDIR/dev/archlinux-extra/packages/* $BASEDIR/dev/archlinux-PKGBUILDs/kde5 && \
cp -a $BASEDIR/dev/archlinux-extra/manual/* $BASEDIR/dev/archlinux-PKGBUILDs/kde5 && \
echo "done."