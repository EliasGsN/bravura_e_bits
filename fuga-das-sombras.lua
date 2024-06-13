-- title:   Fuga das Sombras
-- desc:    RPG de acao 2D
-- version: 0.1
-- script:  lua
jogador = {
    sprite = 32,
    x = 120,
    y = 68
}

function TIC()

    -- cima
    if btn(0) then
        jogador.y = jogador.y - 1
    end
    -- baixo
    if btn(1) then
        jogador.y = jogador.y + 1
    end
    -- esquerda
    if btn(2) then
        jogador.x = jogador.x - 1
    end
    -- direita
    if btn(3) then
        jogador.x = jogador.x + 1
    end

    cls()

    map(0, -- posicao x no mapa
    0, -- posicao y no mapa
    240, -- quanto desenhar x
    138, -- quanto desenhar y
    0, -- em qual ponto colocar o x
    0) -- em qual ponto colocar o y

    spr(jogador.sprite, jogador.x - 8, jogador.y - 8, 0, -- Cor de fundo
    1, -- escala
    0, -- espelhar
    0, -- rotacionar
    2, -- quantos blocos para direita
    2) -- quantos blocos para baixo

end
