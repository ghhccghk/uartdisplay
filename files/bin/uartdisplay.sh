#/bin/sh
#变量
#中文编码为GB2312
#切换指定界面
setjump="0"
#串口屏连接的串口


tty="/dev/ttyUSB0"

#读取固件版本
DISTRIB_ID=$(cat  /etc/openwrt_release | grep DISTRIB_ID | cut -c 13-19)
DISTRIB_REVISION=$(cat  /etc/openwrt_release | grep DISTRIB_REVISION | cut -c 19-25)
sysversion="$DISTRIB_ID $DISTRIB_REVISION"
txt1="固件版本:$sysversion"


#初始化串口

stty -F $tty speed 115200

stty -F $tty speed 115200

#重置

echo "RESET( );\r\n"  > /dev/ttyUSB0

sleep 2

#切换界面
echo "JUMP($setjump);\r\n" > $tty

sleep 2
##写入固件版本
echo "SET_TXT(1,'$txt1');\r\n"  > $tty

sleep 0.1

##需要刷新的文本请写入下面的do命令后面

while true
do

#cpu使用率读取
cpu1=$(echo $(top -b -n 1 | grep CPU | awk '{print $2}' | cut -f 1 -d ".") | cut -c 1-3)

#wifi温度读取
wifitp="$(sensors | grep "temp1" | cut -c 16-19)"
wifitp1="$(echo $wifitp | cut -c 1-5 )"
wifitp2="$(echo $wifitp | cut -c 6-10 )"
wifitp3="$wifitp1°C $wifitp2°C"

#cpu温度读取
cputp=$(cut -c1-3 /sys/class/thermal/thermal_zone0/temp | awk '{print $1/10}')

#sfp模块信息读取 默认为sfp1（WAN）
sfpv=$(ethtool -m eth1 | grep 'Module voltage                            :' | cut -c 46-53)
sfpt=$(ethtool -m eth1 | grep 'Module temperature                        :' | cut -c 46-50)
sfpbiascurrent=$(ethtool -m eth1 | grep 'Laser bias current                        :' | cut -c 46-56)
sfpoutputpower=$(ethtool -m eth1 | grep 'Laser output power                        :' | cut -c 57-67)
sfpopticalpower=$(ethtool -m eth1 | grep 'Receiver signal average optical power     :' | cut -c 57-68)

#网络信息读取

#配置获取的ip的端口
ipvtgetport="pppoe-WAN1"
ipv4=$(ifconfig pppoe-WAN1 | grep 'inet addr:' | grep -oE '([0-9]{1,3}.){3}.[0-9]{1,3}' | head -n 1 )

#配置获取网速的端口
ethn=br-lan

#读取网速

#发送
RX_pre=$(cat /proc/net/dev | grep $ethn | sed 's/:/ /g' | awk '{print $2}')

#接收
TX_pre=$(cat /proc/net/dev | grep $ethn | sed 's/:/ /g' | awk '{print $10}')


#文本信息
txt0=""
txt2="内核版本:$(uname -a | cut -c 15-23)"
txt3="WIFI温度:$wifitp3"
txt4="CPU温度:$cputp°C"
txt5=""
txt6="IPv4地址：$ipv4"
txt8=""
txt9="电压：$sfpv"
txt10="温度：$sfpt°C"
txt11="激光偏置电流：$sfpbiascurrent"
txt12="激光输出功率：$sfpoutputpower"
txt13="接收光功率:$sfpopticalpower"

txt15="CPU使用率:$cpu1"

echo "SET_TXT(6,'$txt6');\r\n" > $tty

sleep 0.2

#写入信息

echo "SET_TXT(2,'$txt2');\r\n"  > $tty

sleep 0.2

echo "SET_TXT(3,'$txt3');\r\n"  > $tty

sleep 0.2

echo "SET_TXT(4,'$txt4');\r\n"  > $tty

sleep 0.2

echo "SET_TXT(9,'$txt9');\r\n" > $tty

sleep 0.2

#发送
RX_next=$(cat /proc/net/dev | grep $ethn | sed 's/:/ /g' | awk '{print $2}')
#接收
TX_next=$(cat /proc/net/dev | grep $ethn | sed 's/:/ /g' | awk '{print $10}')

#网速计算
RX=$((${RX_next}-${RX_pre}))
TX=$((${TX_next}-${TX_pre}))

#计算发送网速
if [[ $RX -lt 1024 ]];then
    RX="${RX}B/s"
elif [[ $RX -gt 1048576 ]];then
    RX=$(echo $RX | awk '{print $1/1048576 "MB/s"}')
else
    RX=$(echo $RX | awk '{print $1/1024 "KB/s"}')
fi

#计算接收网速
if [[ $TX -lt 1024 ]];then
    TX="${TX}B/s"
elif [[ $TX -gt 1048576 ]];then
    TX=$(echo $TX | awk '{print $1/1048576 "MB/s"}')
else
    TX=$(echo $TX | awk '{print $1/1024 "KB/s"}')
fi
####网速显示
txt7="网速：RX:$RX"
txt14="TX:$TX"

echo "SET_TXT(7,'$txt7');\r\n"  > $tty

sleep 0.2

echo "SET_TXT(14,'$txt14');\r\n" > $tty
####不要随便更改位置

sleep 0.2


echo "SET_TXT(10,'$txt10');\r\n"  > $tty

sleep 0.2

echo "SET_TXT(11,'$txt11');\r\n"  > $tty

sleep 0.2

echo "SET_TXT(12,'$txt12');\r\n" > $tty

sleep 0.2

echo "SET_TXT(13,'$txt13');\r\n" > $tty

sleep 0.2

echo "SET_TXT(15,'$txt15');\r\n" > $tty

done
