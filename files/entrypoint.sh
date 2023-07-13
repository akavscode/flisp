#!/usr/bin/env bash

# 设置各变量
WSPATH=${WSPATH:-'lisp'}
UUID=${UUID:-'ffffadd9-5c68-8bab-950c-08cd5320ffff'}
WEB_USERNAME=${WEB_USERNAME:-'admin'}
WEB_PASSWORD=${WEB_PASSWORD:-'password'}

generate_config() {
  cat > config.json << EOF
{
	"log": {
		"access": "none",
		"error": "none",
		"loglevel": "none",
		"dnsLog": false
	},
    "inbounds": [
        {
            "port": 8080,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "${UUID}",
                        "alterId": 0
                    }
                ]
            },
            "streamSettings": {
                "network":"ws",
                "wsSettings": {
                    "path": "/${WSPATH}"
                }
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom",
            "settings": {}
        }
    ],
    "dns":{
        "servers":[
            "https+local://8.8.8.8/dns-query"
        ]
    }
}
EOF
}

# 生成 pm2 配置文件
generate_pm2_file() {
  cat > ecosystem.config.js << EOF
module.exports = {
  "apps":[
      {
          "name":"web",
          "script":"/app/web.js run"
      }
  ]
}
EOF
}

generate_config
generate_pm2_file

[ -e ecosystem.config.js ] && pm2 start
