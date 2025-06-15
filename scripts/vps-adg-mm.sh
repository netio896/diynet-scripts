cat << 'EOF' > /opt/AdGuardHome/AdGuardHome/AdGuardHome.yaml
http:
  pprof:
    port: 6060
    enabled: false
  address: 0.0.0.0:3000
  session_ttl: 720h
users:
  - name: nas
    password: $2a$10$CmGc8P1qV8e/OR.z2ODo5uW4oJgDHadyQp4eO6/3aobEWUnvn6Olq
auth_attempts: 5
block_auth_min: 15
http_proxy: ""
language: ""
theme: auto
dns:
  bind_hosts:
    - 127.0.0.1
    - 0.0.0.0
  port: 53
  aaaa_disabled: true
  upstream_dns:
    - https://dns.adguard.com/dns-query
    - https://dns.cloudflare.com/dns-query
    - https://dns.google/dns-query
  fallback_dns:
    - https://dns.quad9.net/dns-query
    - https://dns.google/dns-query
  bootstrap_dns:
    - 9.9.9.10
    - 149.112.112.10
  upstream_mode: parallel
  cache_size: 4194304
  cache_ttl_min: 60
  cache_ttl_max: 86400
  cache_optimistic: true
  enable_dnssec: true
  edns_client_subnet:
    enabled: true
    use_custom: false
  ratelimit: 20
  bogus_nxdomain: []
  blocked_hosts:
    - version.bind
    - id.server
    - hostname.bind
  serve_http3: false
  use_http3_upstreams: false
  serve_plain_dns: true
  hostsfile_enabled: true
tls:
  enabled: true
  port_https: 443
  port_dns_over_tls: 853
  force_https: false
  allow_unencrypted_doh: false
querylog:
  enabled: true
  file_enabled: true
statistics:
  enabled: true
filtering:
  filtering_enabled: true
  protection_enabled: true
  filters:
    - enabled: true
      url: https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt
      name: AdGuard DNS filter
      id: 1
user_rules:
  - '@@||openai.com^$important'
  - '@@||chat.openai.com^$important'
  - '@@||auth0.openai.com^$important'
  - '@@||cdn.auth0.com^$important'
  - '@@||cdn.openai.com^$important'
  - '@@||chatgpt.com^$important'
EOF
