#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
clear
# VAR 	******************************************************************
vAction=$1
# Function List	*******************************************************************************
function install() {
    #���� VideoStation's ffmpeg
    mv -n /var/packages/VideoStation/target/bin/ffmpeg /var/packages/VideoStation/target/bin/ffmpeg.orig
    #����ffmpeg�ű�
    wget -O - https://gist.githubusercontent.com/BenjaminPoncet/bbef9edc1d0800528813e75c1669e57e/raw/ffmpeg-wrapper >/var/packages/VideoStation/target/bin/ffmpeg
    #���ýű���ӦȨ��
    chown root:VideoStation /var/packages/VideoStation/target/bin/ffmpeg
    chmod 750 /var/packages/VideoStation/target/bin/ffmpeg
    chmod u+s /var/packages/VideoStation/target/bin/ffmpeg
    # ����VideoStation's libsynovte.so
    cp -n /var/packages/VideoStation/target/lib/libsynovte.so /var/packages/VideoStation/target/lib/libsynovte.so.orig
    chown VideoStation:VideoStation /var/packages/VideoStation/target/lib/libsynovte.so.orig
    # Ϊlibsynovte.so ��� DTS, EAC3 and TrueHD֧��
    sed -i -e 's/eac3/3cae/' -e 's/dts/std/' -e 's/truehd/dheurt/' /var/packages/VideoStation/target/lib/libsynovte.so
    echo '����������Video Station��������FFMPEG�Ƿ���������'
}
function uninstall() {
    #�ָ�֮ǰ���ݵ� VideoStation's ffmpeg, libsynovte.so�ļ�
    mv -f /var/packages/VideoStation/target/bin/ffmpeg.orig /var/packages/VideoStation/target/bin/ffmpeg
    mv -f /var/packages/VideoStation/target/lib/libsynovte.so.orig /var/packages/VideoStation/target/lib/libsynovte.so
}

# SHELL 	******************************************************************
if [ "$vAction" == 'install' ]; then
    if [ ! -f "/var/packages/VideoStation/target/bin/ffmpeg.orig" ]; then
        install
    else
        echo '���Ѿ���ӹ�DTS֧��'
        echo '=========================================================================='
        exit 1
    fi
elif [ "$vAction" == 'uninstall' ]; then
    if [ ! -f "/var/packages/VideoStation/target/bin/ffmpeg.orig" ]; then
        echo '�㻹û��װ�� FFMPEG DTS֧�ֲ���'
        echo '=========================================================================='
        exit 1
    else
        uninstall
    fi
else
    echo '���������'
    echo '=========================================================================='
    exit 1
fi