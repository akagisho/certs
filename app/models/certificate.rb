class Certificate < ActiveRecord::Base
  attr_accessible :checked_at, :common_name, :expired_at, :ipv4addr, :issuer, :note, :organization, :port
end
