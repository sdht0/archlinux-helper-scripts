
rm -rf /home/lfiles/dev/archlinux-logs/a && \
mkdir -p /home/lfiles/dev/archlinux-logs/a && \
python /home/lfiles/dev/scripts/parseFrameworks.py && \
rm -rf /home/lfiles/dev/archlinux-logs/b && \
mkdir -p /home/lfiles/dev/archlinux-logs/b && \
python /home/lfiles/dev/scripts/parseWorkspace.py && \
rm -r /home/lfiles/dev/archlinux-PKGBUILDs/kf5/* && \
cp -a /home/lfiles/dev/archlinux-logs/a/* /home/lfiles/dev/archlinux-logs/b/* /home/lfiles/dev/archlinux-PKGBUILDs/kf5 && \
cp -a /home/lfiles/dev/archlinux-logs/manual/* /home/lfiles/dev/archlinux-PKGBUILDs/kf5 && \
echo "done."