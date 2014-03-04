
rm -r /home/lfiles/dev/archlinux-logs/a/*
python /home/lfiles/dev/scripts/parseFrameworks.py && \
rm -r /home/lfiles/dev/archlinux-PKGBUILDs/kf5/* && \
cp -a /home/lfiles/dev/archlinux-logs/a/* /home/lfiles/dev/archlinux-PKGBUILDs/kf5 && \
cp -a /home/lfiles/dev/archlinux-logs/manual/* /home/lfiles/dev/archlinux-PKGBUILDs/kf5