-- title:   Fuga das Sombras
-- desc:    RPG de acao 2D
-- script:  lua
jogador = {
    sprite = 32,
    x = 120,
    y = 68
}

Constantes = {
    LARGURA_DA_TELA = 240,
    ALTURA_DA_TELA = 138
}

function temColisaoComMapa(ponto)
    blocoX = ponto.x / 8
    blocoY = ponto.y / 8
    blocoId = mget(blocoX, blocoY)
    if blocoId >= 128 then
        return true
    else
        return false
    end
end

function moverVertical(meuDeslocamento)
    superiorEsquerdo = {
        x = jogador.x - 8,
        y = jogador.y - 8 + meuDeslocamento
    }
    superiorDireito = {
        x = jogador.x + 7,
        y = jogador.y - 8 + meuDeslocamento
    }
    inferiorDireito = {
        x = jogador.x + 7,
        y = jogador.y + 7 + meuDeslocamento
    }
    inferiorEsquerdo = {
        x = jogador.x - 8,
        y = jogador.y + 7 + meuDeslocamento
    }

    if temColisaoComMapa(superiorEsquerdo) or 
       temColisaoComMapa(superiorDireito) or 
       temColisaoComMapa(inferiorEsquerdo) or
       temColisaoComMapa(inferiorDireito) then
        -- Colisao!!!
    else
        jogador.y = jogador.y + meuDeslocamento
    end
end

function atualiza()
    -- cima
    if btn(0) then
        moverVertical(-1)
    end
    -- baixo
    if btn(1) then
        moverVertical(1)
    end
    -- esquerda
    if btn(2) then
        jogador.x = jogador.x - 1
    end
    -- direita
    if btn(3) then
        jogador.x = jogador.x + 1
    end
end

function desenhaMapa()
    map(0, -- posicao x no mapa
    0, -- posicao y no mapa
    Constantes.ALTURA_DA_TELA, -- quanto desenhar x
    Constantes.LARGURA_DA_TELA, -- quanto desenhar y
    0, -- em qual ponto colocar o x
    0) -- em qual ponto colocar o y
end

function desenhaJogador()
    spr(jogador.sprite, jogador.x - 8, jogador.y - 8, 0, -- Cor de fundo
    1, -- escala
    0, -- espelhar
    0, -- rotacionar
    2, -- quantos blocos para direita
    2) -- quantos blocos para baixo
end

function desenha()

    cls()
    desenhaMapa()
    desenhaJogador()

end

function TIC()
    atualiza()
    desenha()
end
