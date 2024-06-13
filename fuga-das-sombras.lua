-- title:   Fuga das Sombras
-- desc:    RPG de acao 2D
-- script:  lua
jogador = {
    sprite = 256,
    x = 120,
    y = 68,
    corDeFundo = 2,
    quadroDeAnimacao = 1
}

Constantes = {
    LARGURA_DA_TELA = 240,
    ALTURA_DA_TELA = 138,
    VELOCIDADE_ANIMACAO_JOGADOR = 0.1
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

function moverPara(meuDeslocamentoX, meuDeslocamentoY)
    superiorEsquerdo = {
        x = jogador.x - 8 + meuDeslocamentoX,
        y = jogador.y - 8 + meuDeslocamentoY
    }
    superiorDireito = {
        x = jogador.x + 7 + meuDeslocamentoX,
        y = jogador.y - 8 + meuDeslocamentoY
    }
    inferiorDireito = {
        x = jogador.x + 7 + meuDeslocamentoX,
        y = jogador.y + 7 + meuDeslocamentoY
    }
    inferiorEsquerdo = {
        x = jogador.x - 8 + meuDeslocamentoX,
        y = jogador.y + 7 + meuDeslocamentoY
    }

    if temColisaoComMapa(superiorEsquerdo) or temColisaoComMapa(superiorDireito) or temColisaoComMapa(inferiorEsquerdo) or
        temColisaoComMapa(inferiorDireito) then
        -- Colisao!!!
    else
        jogador.quadroDeAnimacao = jogador.quadroDeAnimacao + Constantes.VELOCIDADE_ANIMACAO_JOGADOR
        if jogador.quadroDeAnimacao >= 3 then
            jogador.quadroDeAnimacao = 1
        end
        jogador.y = jogador.y + meuDeslocamentoY
        jogador.x = jogador.x + meuDeslocamentoX
    end
end

function atualiza()

    AnimacoesPersonagem = {{256, 258}, {260, 262}, {264, 266}, {268, 270}}

    -- cima
    if btn(0) then
        jogador.sprite = AnimacoesPersonagem[1][math.floor(jogador.quadroDeAnimacao)]
        moverPara(0, -1)
    end
    -- baixo
    if btn(1) then
        jogador.sprite = AnimacoesPersonagem[2][math.floor(jogador.quadroDeAnimacao)]
        moverPara(0, 1)
    end
    -- esquerda
    if btn(2) then
        jogador.sprite = AnimacoesPersonagem[3][math.floor(jogador.quadroDeAnimacao)]
        moverPara(-1, 0)
    end
    -- direita
    if btn(3) then
        jogador.sprite = AnimacoesPersonagem[4][math.floor(jogador.quadroDeAnimacao)]
        moverPara(1, 0)
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
    spr(jogador.sprite, jogador.x - 8, jogador.y - 8, jogador.corDeFundo, 1, -- escala
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
