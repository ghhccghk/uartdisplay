#/bin/sh
#����
#���ı���ΪGB2312
#�л�ָ������
setjump="0"
#���������ӵĴ���


tty="/dev/ttyUSB0"

#��ȡ�̼��汾
DISTRIB_ID=$(cat  /etc/openwrt_release | grep DISTRIB_ID | cut -c 13-19)
DISTRIB_REVISION=$(cat  /etc/openwrt_release | grep DISTRIB_REVISION | cut -c 19-25)
sysversion="$DISTRIB_ID $DISTRIB_REVISION"
txt1="�̼��汾:$sysversion"


#��ʼ������

stty -F $tty speed 115200

stty -F $tty speed 115200

#����

echo "RESET( );\r\n"  > /dev/ttyUSB0

sleep 2

#�л�����
echo "JUMP($setjump);\r\n" > $tty

sleep 2
echo "SET_TXT(1,'$txt1');\r\n"  > $tty

sleep 0.1

##��Ҫˢ�µ��ı���д�������do�������

while true
do


#cpuʹ���ʶ�ȡ
cpu1=$(echo $(top -b -n 1 | grep CPU | awk '{print $2}' | cut -f 1 -d ".") | cut -c 1-3)

#wifi�¶ȶ�ȡ
wifitp="$(sensors | grep "temp1" | cut -c 16-19)"
wifitp1="$(echo $wifitp | cut -c 1-5 )"
wifitp2="$(echo $wifitp | cut -c 6-10 )"
wifitp3="$wifitp1��C $wifitp2��C"

#cpu�¶ȶ�ȡ
cputp=$(cut -c1-3 /sys/class/thermal/thermal_zone0/temp | awk '{print $1/10}')

#sfpģ����Ϣ��ȡ Ĭ��Ϊsfp1��WAN��
sfpv=$(ethtool -m eth1 | grep 'Module voltage                            :' | cut -c 46-53)
sfpt=$(ethtool -m eth1 | grep 'Module temperature                        :' | cut -c 46-50)
sfpbiascurrent=$(ethtool -m eth1 | grep 'Laser bias current                        :' | cut -c 46-56)
sfpoutputpower=$(ethtool -m eth1 | grep 'Laser output power                        :' | cut -c 57-67)
sfpopticalpower=$(ethtool -m eth1 | grep 'Receiver signal average optical power     :' | cut -c 57-68)

#������Ϣ��ȡ

#���û�ȡ��ip�Ķ˿�
ipvtgetport="pppoe-WAN1"
ipv4=$(ifconfig pppoe-WAN1 | grep 'inet addr:' | grep -oE '([0-9]{1,3}.){3}.[0-9]{1,3}' | head -n 1 )
netrx=$(/bin/net.sh br-lan)
nettx=$(/bin/net1.sh br-lan)

#�ı���Ϣ
txt0=""
txt2="�ں˰汾:$(uname -a | cut -c 15-23)"
txt3="WIFI�¶�:$wifitp3"
txt4="CPU�¶�:$cputp��C"
txt5=""
txt6="IPv4��ַ��$ipv4"
txt7="���٣�$netrx"
txt8=""
txt9="��ѹ��$sfpv"
txt10="�¶ȣ�$sfpt��C"
txt11="����ƫ�õ�����$sfpbiascurrent"
txt12="����������ʣ�$sfpoutputpower"
txt13="���չ⹦��:$sfpopticalpower"
txt14="$nettx"
txt15="CPUʹ����:$cpu1"

echo "SET_TXT(6,'$txt6');\r\n" > $tty

sleep 0.2

#д����Ϣ

echo "SET_TXT(2,'$txt2');\r\n"  > $tty

sleep 0.2

echo "SET_TXT(3,'$txt3');\r\n"  > $tty

sleep 0.2

echo "SET_TXT(4,'$txt4');\r\n"  > $tty

sleep 0.2

echo "SET_TXT(7,'$txt7');\r\n"  > $tty

sleep 0.2

echo "SET_TXT(14,'$txt14');\r\n" > $tty

sleep 0.2

echo "SET_TXT(9,'$txt9');\r\n" > $tty

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
