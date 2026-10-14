# Create simulator
set ns [new Simulator]

# Create trace files
set tf [open lab2.tr w]
$ns trace-all $tf

set nf [open lab2.nam w]
$ns namtrace-all $nf

# Create 6 nodes
for {set i 0} {$i < 6} {incr i} {
    set n($i) [$ns node]
}

# Topology:
# n0, n1, n2 -> n3 (router) -> n4, n5

# Create links: bandwidth, delay, queue type
$ns duplex-link $n(0) $n(3) 1Mb 10ms DropTail
$ns duplex-link $n(1) $n(3) 1Mb 10ms DropTail
$ns duplex-link $n(2) $n(3) 1Mb 10ms DropTail

$ns duplex-link $n(3) $n(4) 0.3Mb 10ms DropTail
$ns duplex-link $n(3) $n(5) 1Mb 10ms DropTail

# Small queue on bottleneck link to create congestion
$ns queue-limit $n(3) $n(4) 5

# Configure link orientations for NAM
$ns duplex-link-op $n(0) $n(3) orient right-down
$ns duplex-link-op $n(1) $n(3) orient right
$ns duplex-link-op $n(2) $n(3) orient right-up
$ns duplex-link-op $n(3) $n(4) orient right-up
$ns duplex-link-op $n(3) $n(5) orient right-down

# Customize Ping output
Agent/Ping instproc recv {from rtt} {
    $self instvar node_
    puts "node [$node_ id] received ping answer from $from with round-trip-time $rtt ms."
}

# Create Ping agents
set p0 [new Agent/Ping]
set p4 [new Agent/Ping]
set p1 [new Agent/Ping]
set p5 [new Agent/Ping]

# Attach Ping agents to nodes
$ns attach-agent $n(0) $p0
$ns attach-agent $n(4) $p4
$ns attach-agent $n(1) $p1
$ns attach-agent $n(5) $p5

# Connect Ping agents
$ns connect $p0 $p4
$ns connect $p1 $p5

# Create UDP traffic from n2 to n4
set udp [new Agent/UDP]
$ns attach-agent $n(2) $udp

set null [new Agent/Null]
$ns attach-agent $n(4) $null

$ns connect $udp $null

# Create CBR application
set cbr [new Application/Traffic/CBR]
$cbr set packetSize_ 1000
$cbr set rate_ 0.6Mb
$cbr attach-agent $udp

# Configure Ping packet sizes
$p0 set packetSize_ 500
$p1 set packetSize_ 500

# Finish procedure
proc finish {} {
    global ns tf nf

    $ns flush-trace
    close $tf
    close $nf

    puts "Simulation completed."
    exit 0
}

# Schedule Ping packets
foreach t {
    0.1 0.3 0.5 0.7 0.9
    1.1 1.3 1.5 1.7 1.9
    2.1 2.3 2.5 2.7 2.9
} {
    $ns at $t "$p0 send"
    $ns at $t "$p1 send"
}

# Start and stop background traffic
$ns at 0.5 "$cbr start"
$ns at 2.5 "$cbr stop"

# End simulation
$ns at 3.0 "finish"

# Run simulation
$ns run
