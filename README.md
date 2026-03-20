# Besu en Docker

Blockchain Besu de ejemplo en Docker.

## Puesta en marcha

Inicializar Poetry:

```shell
make init
```

Generar la configuración de la red:

```shell
make blockchain
```

Arrancar los servicios:

```shell
make start
```

## Comprobar la red

Mostrar el comando para conectar al RPC:

```shell
make mostrar_websocat
```

Conectar al workspace:

```shell
make workspace
```

Lanzar el comando de `websocat` y pegar la petición:

```
{"jsonrpc": "2.0", "method": "qbft_getValidatorsByBlockNumber", "params": ["latest"], "id": 1}
```

Debería devolver los nodos validadores:

```
{"jsonrpc":"2.0","id":1,"result":["0x219d88c04a1c4421b49425ad0010a2c3bd4f7dd1","0x5c1b8e90d15d396c1faebae173ca3703f39fb93b","0x87f16a9c74e5ab30da95541e08cf02fbc7cdee5b","0xc1858eb0282fc2dc8163e0a5e1c58a1c70b290c0","0xc2e3c7986141062c77f01606bdd789b3e6dc1c93"]}
```

## Referencias

- [Besu Ethereum client](https://besu.hyperledger.org/)
- [vi/websocat: Command-line client for WebSockets, like netcat (or curl) for ws:// with advanced socat-like functions](https://github.com/vi/websocat)
- [goerli/ethstats-server: Ethereum network status dashboard for PoW and PoA networks](https://github.com/goerli/ethstats-server)
- [Private network API methods | Besu documentation](https://besu.hyperledger.org/private-networks/reference/api#qbft-methods)
