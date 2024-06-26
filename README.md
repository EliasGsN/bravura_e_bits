# Bravura & Bits

**Autor**: Elias  
**Descrição**: RPG de ação 2D desenvolvido no TIC-80 usando a linguagem de programação Lua.

## Sobre o Jogo

"Bravura & Bits" é um emocionante RPG de ação 2D onde o jogador deve navegar por um mapa, coletar chaves, abrir portas e evitar inimigos. O jogo apresenta animações simples e uma mecânica de colisão básica.

## Controles

- **Seta para cima**: Mover para cima
- **Seta para baixo**: Mover para baixo
- **Seta para esquerda**: Mover para esquerda
- **Seta para direita**: Mover para direita

## Objetivos

- Colete chaves para abrir portas e progredir pelo mapa.
- Evite ou enfrente inimigos enquanto busca as chaves.

## Instalação e Execução

Para jogar "Bravura & Bits", você precisa do TIC-80. Siga as instruções abaixo:

1. **Baixe e instale o TIC-80**:
   - Acesse o site oficial do TIC-80: [TIC-80](https://tic80.com/)
   - Siga as instruções de download e instalação para o seu sistema operacional.

2. **Carregue o jogo no TIC-80**:
   - Abra o TIC-80.
   - Carregue o script do jogo (`bravura_e_bits.lua`) usando o comando `load` no console do TIC-80.

3. **Execute o jogo**:
   - Digite `run` no console do TIC-80 para iniciar o jogo.

## Estrutura do Código

O código do jogo está estruturado da seguinte forma:

- **Constantes**: Define valores constantes usados no jogo, como tamanhos da tela, velocidades, sprites e IDs de efeitos sonoros.
- **Funções de Colisão**: Verifica colisões com o mapa e com objetos.
- **Funções de Movimentação**: Move o jogador e os inimigos.
- **Funções de Atualização e Desenho**: Atualiza o estado do jogo e desenha o mapa, o jogador e os objetos na tela.
- **Inicialização**: Inicializa o jogo, criando objetos e definindo o estado inicial do jogador.
- **Loop Principal (TIC)**: Função principal do TIC-80 que atualiza e desenha o jogo a cada frame.

## Licença

Este projeto é licenciado sob a [MIT License](LICENSE).

## Contribuições

Contribuições são bem-vindas! Se você encontrar bugs ou tiver ideias para melhorias, sinta-se à vontade para abrir uma issue ou enviar um pull request.
