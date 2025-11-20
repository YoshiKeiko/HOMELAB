{\rtf1\ansi\ansicpg1252\cocoartf2822
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\froman\fcharset0 Times-Roman;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;}
{\*\expandedcolortbl;;\cssrgb\c0\c0\c0;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\sa240\partightenfactor0

\f0\fs24 \cf0 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 #!/bin/bash\
\
echo "=== System Network Configuration ==="\
# Check network interface info\
echo "Network interfaces:"\
ifconfig -a | grep -E 'en[0-9]+'\
\
echo "Current system MTU:"\
ifconfig en0 | grep mtu\
\
echo "=== Testing Network Speed ==="\
# Run iperf3 to check network performance (local test between Mac and another iperf3 server)\
echo "Running local iperf3 test..."\
iperf3 -c 127.0.0.1 -t 10 -i 1\
\
echo "=== Checking Docker Container Network Performance ==="\
# Check running Docker containers network statistics\
docker ps\
echo "Docker container network stats (if applicable):"\
docker stats --no-stream\
\
echo "=== Checking System Resource Usage ==="\
# Check system resource usage (CPU, Memory)\
top -l 1 | head -n 20\
\
echo "=== Checking for Network Errors ==="\
# Check for network interface errors\
netstat -i\
\
echo "=== Running Speedtest (ISP performance) ==="\
# Run speedtest to measure internet connection speed (down/up)\
speedtest-cli --simple\
\
echo "=== Checking Active Network Connections ==="\
# Check for active network connections that might be affecting performance\
netstat -anp tcp\
\
echo "=== Checking Docker Container Limitations ==="\
# Check if docker containers are limiting network bandwidth (via --network host, etc.)\
docker inspect $(docker ps -q) | grep -i 'Network'\
\
echo "=== Conclusion ==="\
echo "Review the output of these tests to identify bottlenecks."\
echo " - Check if your 10GbE network interface is being detected correctly."\
echo " - Ensure there are no network errors or dropped packets."\
echo " - Review Docker stats and container limits (CPU, memory, bandwidth)."\
echo " - Check if your internet connection is actually hitting 5Gb (test with Speedtest)."\
echo " - Inspect if your system resources (CPU, RAM) are fully utilized."\
}