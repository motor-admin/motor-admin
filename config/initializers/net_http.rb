# frozen_string_literal: true

File.write('/tmp/motor-admin.pem', File.read(NetHttpSslFix::LOCAL_CA_FILE))

Kernel.silence_warnings do
  NetHttpSslFix.const_set(:LOCAL_CA_FILE, '/tmp/motor-admin.pem')
end
