FROM jlesage/baseimage-gui:debian-10 AS BUILDER
  RUN apt update && apt install -y curl unzip

  RUN curl -L -O https://cdn.prusa3d.com/downloads/drivers/prusa3d_linux_2_4_0.zip && \
    unzip prusa3d_linux_2_4_0.zip && \
    chmod +x PrusaSlicer-2.4.0+linux-x64-202112211614.AppImage && \
    cp PrusaSlicer-2.4.0+linux-x64-202112211614.AppImage /usr/bin/PrusaSlicer-2.4.0+linux-x64-202112211614.AppImage

  RUN /usr/bin/PrusaSlicer-2.4.0+linux-x64-202112211614.AppImage --appimage-extract && \
      mv /tmp/squashfs-root /opt/prusaslicer && \
      chmod +x /opt/prusaslicer/AppRun


FROM golang:1.13 AS GO_BUILDER
  RUN mkdir /app && \
    git clone https://github.com/AverageMarcus/uv3dp.git && \
    cd uv3dp && \
    go build -o /app/uv3dp ./cmd/uv3dp


FROM jlesage/baseimage-gui:debian-10
  COPY --from=BUILDER /opt/prusaslicer /opt/prusaslicer
  COPY --from=GO_BUILDER /app/uv3dp /usr/bin/

  RUN apt-get update && \
      apt-get install -y --no-install-recommends freeglut3 libgtk2.0-dev libwxgtk3.0-dev libwx-perl libxmu-dev libgl1-mesa-glx libgl1-mesa-dri xdg-utils locales inotify-tools && \
      rm -rf /var/lib/apt/lists/* && \
      apt-get autoremove -y && \
      apt-get autoclean

  RUN sed -i -e 's/^# \(cs_CZ\.UTF-8.*\)/\1/' -e 's/^# \(de_DE\.UTF-8.*\)/\1/' -e 's/^# \(en_US\.UTF-8.*\)/\1/' -e 's/^# \(es_ES\.UTF-8.*\)/\1/' -e 's/^# \(fr_FR\.UTF-8.*\)/\1/' \
      -e 's/^# \(it_IT\.UTF-8.*\)/\1/' -e 's/^# \(ko_KR\.UTF-8.*\)/\1/' -e 's/^# \(pl_PL\.UTF-8.*\)/\1/' -e 's/^# \(uk_UA\.UTF-8.*\)/\1/' -e 's/^# \(zh_CN\.UTF-8.*\)/\1/' /etc/locale.gen && \
      locale-gen && \
      sed-patch 's/<application type="normal">/<application type="normal" title="PrusaSlicer">/' /etc/xdg/openbox/rc.xml

  ADD src/convert.sh /convert.sh
  ADD src/startapp.sh /startapp.sh
  ADD config/ /config/xdg/config/PrusaSlicer/

  RUN chmod +x /usr/bin/uv3dp /convert.sh /startapp.sh

  ENV APP_NAME="PrusaSlicer"
  ENV USER_ID=0
  ENV GROUP_ID=0
  ENV DISPLAY_WIDTH=2340
  ENV DISPLAY_HEIGHT=1542
  ENV KEEP_APP_RUNNING=1

  # Set this to false to disable the uv3dp auto-convert of sl1 to cbt files.
  ENV AUTO_CONVERT_SL1=true
