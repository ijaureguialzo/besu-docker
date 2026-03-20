#!/usr/bin/env python3
"""
Genera docker-compose.yml con N nodos besu-nodeX.

Uso:
    python scripts/generar_compose 5
"""

import argparse
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).parent.parent
OUTPUT = REPO_ROOT / "docker-compose.override.yml"

NODE_TEMPLATE = """\
  besu-node{n}:
    image: hyperledger/besu:${{BESU_VERSION:-26.2.0}}
    hostname: besu-node{n}
    volumes:
      - ./private/jwts:/var/lib/besu/jwts
      - ./private/networkFiles:/var/lib/besu/QBFT-Network/networkFiles
      - ./besu:/var/lib/besu/config
      - ./private/node_data/besu-node{n}:/var/lib/besu/QBFT-Network/Node
    command: --config-file=/var/lib/besu/config/node-config.toml
    networks:
      besu_network:
        ipv4_address: 192.168.100.{n}
    environment:
      - BESU_NODE_PRIVATE_KEY_FILE=/var/lib/besu/QBFT-Network/networkFiles/keys/key{n}
      - BESU_ETHSTATS=besu-node{n}:${{WS_SECRET:-asdf}}@ethstats-server:3000
      - BESU_RPC_WS_AUTHENTICATION_ENABLED=true
      - BESU_RPC_WS_AUTHENTICATION_JWT_ALGORITHM=RS256
      - BESU_RPC_WS_AUTHENTICATION_JWT_PUBLIC_KEY_FILE=/var/lib/besu/jwts/{n}/publicRSAKeyOperator{n}.pem

"""


def main():
    parser = argparse.ArgumentParser(
        description="Genera docker-compose.yml con N nodos besu."
    )
    parser.add_argument("n", type=int, help="Número de nodos besu a generar")
    args = parser.parse_args()

    if args.n < 1:
        print("ERROR: El número de nodos debe ser al menos 1.", file=sys.stderr)
        sys.exit(1)

    if args.n > 253:
        print("ERROR: El número máximo de nodos es 253 (límite de la subred /24).", file=sys.stderr)
        sys.exit(1)

    content = "services:\n"
    for i in range(1, args.n + 1):
        content += NODE_TEMPLATE.format(n=i)

    OUTPUT.write_text(content)
    print(f"✓ {OUTPUT} generado con {args.n} nodo(s) besu.")


if __name__ == "__main__":
    main()
