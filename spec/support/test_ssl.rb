module TestSsl
  # A real SSL certificate and key for testing purposes
  #
  # Generated mostly in the same way as the real certs:
  #
  # Generate the key:
  #   openssl genrsa -des3 -out test.key 4096
  #
  # Strip the password from the key:
  #   openssl rsa -in test.key -out test.key
  #
  # Generate a signing request:
  #   openssl req -new -key test.key -out test.csr
  #
  # Sign the cert (for the real certs this part was done by dxw ops)
  #   openssl x509 -req -sha256 -days 3650 -in test.csr -signkey test.key -out test.crt

  def self.key
    <<~EOF
      -----BEGIN RSA PRIVATE KEY-----
      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
      -----END RSA PRIVATE KEY-----
    EOF
  end

  def self.certificate
    <<~EOF
      -----BEGIN CERTIFICATE-----
        MIIFBjCCAu4CCQDmS4ztMeTTYDANBgkqhkiG9w0BAQsFADBFMQswCQYDVQQGEwJB
      VTETMBEGA1UECBMKU29tZS1TdGF0ZTEhMB8GA1UEChMYSW50ZXJuZXQgV2lkZ2l0
      cyBQdHkgTHRkMB4XDTE3MTAyNjIwMjE1OVoXDTI3MTAyNDIwMjE1OVowRTELMAkG
      A1UEBhMCQVUxEzARBgNVBAgTClNvbWUtU3RhdGUxITAfBgNVBAoTGEludGVybmV0
      IFdpZGdpdHMgUHR5IEx0ZDCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIB
      AM08appfnVj1rEtG70+sGKef0ySLAzGIwYvYlHGLi11rUcdD6Kll3kw74CHL+y4+
        0DDUILoSvtHAhiT1zs7cam5/OZsPeL1MNE1UjumZABG/bDqXa8Gkn6nPIq33glMC
      dzucc7ErRnE2KyxF7E4b7hcbtBffL5iN6cFV04qzO3O/0piKXWkQAQrhW6eSrgff
      5VlkqgpgK14WE1utXURHqeu1ufwp6G8QhRmvzk6BObrIzCY4llzRsEO4/cLRw2YH
      9uG+sCs9Ov3+sm9TaUpTQdTm3j78Uh6c9XN3JrR72+PJhKckHbIaA/EDnYasH6iS
      YRu9O3t2BUAkTolmOWhbBO1j+J6NYQP31FGi799bT5GwAwFzjcs6vpOGGXgWRuMa
      rgh5AZfW6qeSokp5ONFf02K6UKrSt2nwfxYXFxeXZSegxL3xs61SZQl8JGmc5NoP
      YYJUjTgTM99fp/D6eCtSllaQh/q005LE8u607agJleYCSVDIOPIEfKu0wyRkpK6T
      kDvt/JfMVHQHx1R611VdgxfgzTwMpmecerzICOHNCaBo5UvwLhIVxlbTrK53lnIz
      5H5GAY/w+1lBbniMRFO9qHZ1usPUFQfoNk8uOqPSedtvevzD4A99uam68qdRlpNd
      YOYKhF9s3COpGIPz99pS9R7PWtwBB5x4dVhvIEiMllirAgMBAAEwDQYJKoZIhvcN
      AQELBQADggIBAFns233S9DipBKBCVBw+OUXJwxaNId8x2m+frr1hH0NNf+aCNEIP
      IfofFekm5wEm5F3BF5snv2H1MKgh6LTg+6LUf6hIyKADr+OufJ108UvpImOMsfSd
      BtO259h2pjE8+6qW62Ivgwnt8aVGxHef/c3h0pbn5oo9crZ/oSZ9XYKNE77iBuun
      uByZkKLat5d5eb5PjxvgkXWFq2LkRoFxZB+Df2gMTK2SNNm3G4/N8m+e9w2KvJmn
      HsBz/3YptjNFnhEskG7K33gEbrnQ87IDXHockUz6EiQOngbrHarj9psL8UZ7d6oe
      kvdEbNTUfsuL4ntIAK0kcExTrjt7OdKCDS1M/O/IixgSwDALeXNHVOtRLSIdfhLC
      9J4vbm9tRUyN85s6LhhylQNXVlc6zWg27VrzBmc/1ddCLFy+G41asoIz9LEPhhQs
      VXITcE2zHwgIFj9upTrayH73jODSC5HpQzdsI+DI37pYlO6MTBTIUO+/9roDvJYh
      dz3QPmsaqveyDCu4WXv2I2FRbFg0SGYrHQVRjXCt7cmeZvdyvc9lhafpQASFqjJF
      7cfFIudj1pWYqYGGrdYi02em0mAWGfNWQNx8wrkpuFuKiABUDXOdAK9ju9FQmThx
      1P8u65W3kAsHeVmtdQJNO11smWuhDEKRR/+eY1/8RfXBIdfTHDhPC1LO
      -----END CERTIFICATE-----
    EOF
  end
end
