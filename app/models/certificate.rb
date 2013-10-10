include CertUtil

class Certificate < ActiveRecord::Base
  attr_accessible :checked_at, :common_name, :expired_at, :ipv4addr, :issuer, :note, :organization, :port

  validates :common_name,
    :presence => true,
    :length => { :maximum => 255 },
    :format => { :with => /^[a-z0-9\-\.]+\.[a-z]+$/i }
  validates :ipv4addr,
    :length => { :maximum => 15 },
    :format => {
      :allow_blank => true,
      :with => /^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$/
    }
  validates :port,
    :numericality => {
      :allow_blank => true,
      :only_integer => true,
      :greater_than => 0,
      :less_than => 65536
    }

  def life
    life = nil
    if self.expired_at.class.to_s == 'ActiveSupport::TimeWithZone' then
      life = ((self.expired_at - Time.now) / (60*60*24)).to_i;
    end
    return life
  end

  def update_expiration
    host = !ipv4addr.nil? && !ipv4addr.empty? ? ipv4addr : common_name
    cert = CertUtil.get_cert(host, port)
    subject = CertUtil.parse_subject(cert.subject.to_s)
    issuer = CertUtil.parse_subject(cert.issuer.to_s)

    self.organization = subject['O']
    self.issuer = issuer['O']
    self.expired_at = cert.not_after
    self.checked_at = Time.now
    self.save
  end
end
