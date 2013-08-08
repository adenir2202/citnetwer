require "active_model"
require 'ipscanner'
require 'socket'
require 'snmp'
require 'logger'

#Active Model Serialization
#http://api.rubyonrails.org/classes/ActiveModel/Serialization.html


class Host
  include ActiveModel::Serializers::Xml
  
  def initialize(ip, name, mac, iface, pingMethod, discoveryMethod)
    @ip = ip
    @name = name
    @mac = mac
    @iface = iface
    @pingMethod = pingMethod
    @discoveryMethod = discoveryMethod
  end
  
  attr_reader :ip, :name, :mac, :iface, :pingMethod, :discoveryMethod
  def attributes
    {'ip' => nil, 'name' => nil, 'mac' => nil, 'iface' => nil, 'pingMethod' => nil, 'discoveryMethod' => nil }
  end  
  
  # routines to convert between dotted strings <-> integer IPs
  
  def self.ip_to_int(ipstring)
    v = 0
    ipstring.split(".").reverse.each do |s|
      v = (v << 8) + (s.to_i)
    end
    return v
  end
    
  def self.int_to_ip(v)
    array = []
    n = 4
    begin
      array << (v % 0x100).to_s
      v >>= 8
    end while((n -= 1) > 0)
    return array.join(".")
  end
    
  # routine to convert string characters to int array
  # used in SSID encoding
    
  def self.string_to_int_array(s)
    return "[" + s.unpack("c*").join(",") + "]"
  end
    
  def self.portIsOpen?(ip, port)
    begin
      Timeout::timeout(1) do
        begin
          s = UDPSocket.new
          s.connect(ip, port)
          s.close
          puts "Host: #{ip} port:#{port} is opened"
          true
        rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
          puts "Host: #{ip} port:#{port} is closed"
          false
        end
      end
    rescue Timeout::Error
      false
    end
  
  end


#
# Tests whether a remote UDP port is open.
#
# @param [String] host
#   The host to connect to.
#
# @param [Integer] port
#   The port to connect to.
#
# @param [String] local_host (nil)
#   The local host to bind to.
#
# @param [Integer] local_port (nil)
#   The local port to bind to.
#
# @param [Integer] timeout (5)
#   The maximum time to attempt connecting.
#
# @return [Boolean, nil]
#   Specifies whether the remote UDP port is open.
#   If no data or ICMP error were received, `nil` will be returned.
#
# @since 0.5.0
#
  def self.udp_open?(host,port,local_host=nil,local_port=nil,timeout=nil)
    timeout ||= 5
  
    begin
      Timeout.timeout(timeout) do
        udp_session(host,port,local_host,local_port) do |socket|
          # send an empty UDP packet, just like nmap
          socket.syswrite('')
  
          # send junk data, to elicit an error message
          socket.syswrite("\0" * 64)
  
          # test if we've received any data
          socket.sysread(1)
        end
      end
  
      return true
    rescue Timeout::Error
      return nil
    rescue SocketError, SystemCallError
      return false
    end
  end

#----------------------------------- Returns my ip
  def self.myIp()
    computer = ""
    puts "........((((((((((((((()))))))))))))))"
    addr = UDPSocket.open {|s| 
      s.connect("255.255.255.0", 1); 
      computer = s.addr.last}
    return computer
  end


end

# p051gamecharacters.rb
class Hosts
  include ActiveModel::Serializers::Xml
#  include ActiveModel::Serializers::JSON
  
   def initialize(rede)
    @rede = rede
    self.hosts = []
   end
   
   attr_accessor :rede, :hosts
   
   def addHost(ip, mac)
      self.ips.push(ip)
      self.macs.push(mac)
   end
   
  # override scan method
    def self.scanWsockt(ip_base = '10.2.1.', range = 1..254, t = 50)
        threads = []  
        computers =[]
        Socket.do_not_reverse_lookup = false    
        (range).map {  |i| 
            threads << Thread.new {
                ip = ip_base + i.to_s
                if IPScanner.pingecho(ip, t) 
                    computers << Socket.getaddrinfo(ip, nil)[0][2]                    
                end
            }
        }.join      
        # wait for all threads to terminate
        threads.each { |thread| thread.join }
        return computers
    end
    
    #---------------------------------- Returns all computers in network
    # saida do comando arp -a
    #(10.2.1.2) em 00:0c:29:16:b3:27 [ether] em p4p1
    def scanWarp(command = 'arp -a')
      self.hosts = [] 
      lines = IO.popen(command)
      lines.each do |sys|
        if sys.count(' ') == 6
          m = sys.split
          ip = "#{m[1].sub(/\((.*)\)/,'\1')}"
          mac = "#{m[3]}"
          iface = "#{m[6]}"
          hosts.push(Host.new(ip, "host#{ip}", mac, iface, "ping", "nmap"))
        end
      end
    end
    
    #---------------------------------- Returns all computers in network
    #------- Saida do comando nmpa: Nmap scan report for 10.2.1.199
    #                               Host is up (0.00043s latency).   
      def self.scanWnmap(command = "nmap -n -sP -T4 #{host.myIp()}/24")
        computers = [] 
        lines = IO.popen(command)
    
        lines.each do |sys|
          if sys =~ /^Nmap scan/
            m = sys.split
            computers << "#{m[4]}"
          end
        end
        
        return computers
      end
     
       
   def attributes
    {'rede' => nil, 'hosts' => nil}
  end  
end

