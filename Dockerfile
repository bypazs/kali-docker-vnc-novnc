FROM kalilinux/kali-rolling:latest
LABEL description="Kali Linux with XFCE Desktop via VNC and noVNC in browser. "
LABEL description="WARNING needs to be saved als LT end of line file"

# Install kali packages
ARG KALI_METAPACKAGE=default
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install kali-linux-${KALI_METAPACKAGE}
RUN apt-get clean

# Install kali desktop
ARG KALI_DESKTOP=xfce
RUN apt-get -y install kali-desktop-${KALI_DESKTOP}
RUN apt-get -y install dbus dbus-x11 novnc net-tools
ENV USER root
ENV VNCEXPOSE 1
ENV VNCPORT 5900
ENV VNCPWD P@ssw0rd
ENV VNCDISPLAY 1920x1080
ENV VNCDEPTH 16
ENV NOVNCPORT 9090
ENV TZ=Asia/Bangkok

# Install custom packages
RUN apt-get -y install nano seclists gobuster 
RUN useradd -rm -d /home/sosecure -s /bin/zsh -g root -G sudo -u 1001 sosecure
RUN echo 'sosecure:P@ssw0rd' | chpasswd
WORKDIR /home/sosecure

# fix anoying shit
#RUN apt-get install xfce4 tigervnc-standalone-server -y
RUN apt-get remove xfce4-power-manager -y
RUN apt-get install autocutsel inetutils-ping htop -y
#RUN apt remove qterminal -y
#RUN apt install xfce4-terminal -y
RUN apt-get clean
RUN apt-get autoremove -y
RUN mkdir /home/sosecure/Desktop
RUN touch /home/sosecure/Desktop/README.txt
RUN echo "To enable copy/paste run: autocutsel -fork" >> /home/sosecure/Desktop/README.txt
# Gimmick
RUN echo 'Try Harder!\nGrim The Ripper Team by SOSECURE Thailand\nhttps://github.com/bypazs/GrimTheRipper' >> /root/bypazs.txt

# Extract Wordlist
RUN sudo gunzip /usr/share/wordlists/rockyou.txt.gz

# Entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
