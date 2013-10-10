require 'socket'
require 'openssl'
require 'timeout'
include OpenSSL

module CertUtil
  def get_cert(host, port = nil, timeout = 10)
    port = 443 if port.nil?

    ssl_conf = SSL::SSLContext.new()
    begin
      timeout(timeout) {
        @soc = TCPSocket.new(host.to_s, port.to_i)
        @ssl = SSL::SSLSocket.new(@soc, ssl_conf)
        @ssl.connect
      }

    rescue => e
      raise "#{e.class} #{e.message}"
    end

    cert = @ssl.peer_cert

    @ssl.close
    @soc.close

    return cert
  end

  def parse_subject(subject)
    data = {}

    pairs = subject.split("/")
    pairs.each do |pair|
      (key, val) = pair.split("=")
      next if key.to_s.empty?
      data[key] = val
    end

    return data
  end
end
