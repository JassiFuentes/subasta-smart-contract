// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Subasta {
    address public dueno;
    uint public tiempoFinalizacion;
    uint public porcentajeIncrementoMinimo = 5;
    uint public comision = 2;

    address public mejorOferente;
    uint public mejorOferta;
    bool public finalizada;

    mapping(address => uint) public ofertas;
    address[] public oferentes;

    event NuevaOferta(address indexed oferente, uint monto);
    event SubastaFinalizada(address ganador, uint monto);

    constructor(uint _duracionEnMinutos) {
        dueno = msg.sender;
        tiempoFinalizacion = block.timestamp + (_duracionEnMinutos * 1 minutes);
    }

    modifier soloAntesDeFinalizar() {
        require(block.timestamp < tiempoFinalizacion, "Subasta finalizada");
        _;
    }

    modifier soloDespuesDeFinalizar() {
        require(block.timestamp >= tiempoFinalizacion || finalizada, "Subasta no finalizada");
        _;
    }

    function ofertar() public payable soloAntesDeFinalizar {
        require(msg.value > 0, "Debes enviar ETH");

        uint ofertaAnterior = ofertas[msg.sender];
        uint ofertaTotal = ofertaAnterior + msg.value;

        require(
            ofertaTotal >= mejorOferta + (mejorOferta * porcentajeIncrementoMinimo) / 100,
            "La oferta no supera el minimo incremento requerido"
        );

        ofertas[msg.sender] = ofertaTotal;

        if (ofertaAnterior == 0) {
            oferentes.push(msg.sender);
        }

        mejorOferente = msg.sender;
        mejorOferta = ofertaTotal;

        if (tiempoFinalizacion - block.timestamp <= 10 minutes) {
            tiempoFinalizacion += 10 minutes;
        }

        emit NuevaOferta(msg.sender, ofertaTotal);
    }

    function verGanador() public view returns (address, uint) {
        return (mejorOferente, mejorOferta);
    }

    function mostrarOfertas() public view returns (address[] memory, uint[] memory) {
        uint[] memory montos = new uint[](oferentes.length);
        for (uint i = 0; i < oferentes.length; i++) {
            montos[i] = ofertas[oferentes[i]];
        }
        return (oferentes, montos);
    }

    function finalizarSubasta() public soloDespuesDeFinalizar {
        require(!finalizada, "Ya finalizada");
        finalizada = true;

        uint comisionDueno = (mejorOferta * comision) / 100;
     // Comision ya transferida, no es necesario calcular envioGanador

        payable(dueno).transfer(comisionDueno);

        for (uint i = 0; i < oferentes.length; i++) {
            address participante = oferentes[i];
            if (participante != mejorOferente) {
                payable(participante).transfer(ofertas[participante]);
            }
        }

        emit SubastaFinalizada(mejorOferente, mejorOferta);
    }

    function retirarExceso() public soloAntesDeFinalizar {
        uint oferta = ofertas[msg.sender];
        require(oferta > 0, "No has ofertado");
        require(msg.sender != mejorOferente, "No puedes retirar si eres el mejor postor");

        uint reembolso = oferta;
        ofertas[msg.sender] = 0;

        payable(msg.sender).transfer(reembolso);
    }
}