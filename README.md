# Subasta Smart Contract - Trabajo Final Módulo 2

Este proyecto es una subasta descentralizada en Solidity desplegada en la red Sepolia como parte del curso Ethereum Developer.

## 📜 Contrato desplegado

- Dirección: `0xe240fCA7b487FFaad32e7cf821ffeB6c32A514B0`
- Etherscan: (https://sepolia.etherscan.io/address/0xe240fCA7b487FFaad32e7cf821ffeB6c32A514B0#code)
- Wallet: `0x2edCC9A7c764898E9A26c1B7CE581124B0c52e8f`


## ⚙️ Funcionalidades

- ✅ Constructor: Inicializa la subasta con duración en minutos.
- ✅ Ofertar: Los usuarios pueden ofertar al menos 5% más que la oferta actual.
- ✅ Ver ganador: Devuelve la dirección y monto del ganador.
- ✅ Ver historial de ofertas.
- ✅ Retiro de depósitos para los no ganadores.
- ✅ Comisión del 2% para el dueño al finalizar.
- ✅ Extensión automática si se ofertó en los últimos 10 minutos.

## 🛠️ Uso

El contrato se despliega con una duración en minutos:
```solidity
Subasta(30) // 30 minutos de duración

## 📢 Eventos

- `NuevaOferta`: Cada vez que se realiza una oferta válida.
- `SubastaFinalizada`: Al finalizar la subasta.

## 👨‍💻 Autor

Trabajo realizado por Jassira Ramos como parte del Módulo 2 del curso Ethereum Developer.

