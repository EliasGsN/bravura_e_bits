-- title:   Fuga das Sombras
-- desc:    RPG de acao 2D
-- script:  lua
jogador = {
    sprite = 260,
    x = 100,
    y = 68,
    corDeFundo = 2,
    quadroDeAnimacao = 1,

    chaves = 0
}

Constantes = {
    LARGURA_DA_TELA = 240,
    ALTURA_DA_TELA = 138,
    VELOCIDADE_ANIMACAO_JOGADOR = 0.1,

    SPRITE_CHAVE = 364,
    SPRITE_PORTA = 366
}

objetos = {}

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

function moverPara(delta)

    superiorEsquerdo = {
        x = jogador.x - 8 + delta.deltaX,
        y = jogador.y - 8 + delta.deltaY
    }
    superiorDireito = {
        x = jogador.x + 7 + delta.deltaX,
        y = jogador.y - 8 + delta.deltaY
    }
    inferiorDireito = {
        x = jogador.x + 7 + delta.deltaX,
        y = jogador.y + 7 + delta.deltaY
    }
    inferiorEsquerdo = {
        x = jogador.x - 8 + delta.deltaX,
        y = jogador.y + 7 + delta.deltaY
    }

    if not (temColisaoComMapa(superiorEsquerdo) or temColisaoComMapa(superiorDireito) or
        temColisaoComMapa(inferiorEsquerdo) or temColisaoComMapa(inferiorDireito)) then

        jogador.quadroDeAnimacao = jogador.quadroDeAnimacao + Constantes.VELOCIDADE_ANIMACAO_JOGADOR
        if jogador.quadroDeAnimacao >= 3 then
            jogador.quadroDeAnimacao = 1
        end
        jogador.y = jogador.y + delta.deltaY
        jogador.x = jogador.x + delta.deltaX
    end
end

function atualiza()

    Direcao = {{
        deltaX = 0,
        deltaY = -1
    }, {
        deltaX = 0,
        deltaY = 1
    }, {
        deltaX = -1,
        deltaY = 0
    }, {
        deltaX = 1,
        deltaY = 0
    }}

    AnimacaoJogador = {{256, 258}, {260, 262}, {264, 266}, {268, 270}}

    for tecla = 0, 3 do
        if btn(tecla) then
            quadros = AnimacaoJogador[tecla + 1]
            quadro = math.floor(jogador.quadroDeAnimacao)
            jogador.sprite = quadros[quadro]

            moverPara(Direcao[tecla + 1])
        end
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

function desenhaObjetos()
    for indice, objeto in pairs(objetos) do
        spr(objeto.sprite, objeto.x - 8, objeto.y - 8, objeto.corDeFundo, 1, 0, 0, 2, 2)
    end
end

function desenha()
    cls()
    desenhaMapa()
    desenhaJogador()
    desenhaObjetos()
end

function fazColisaoDoJogadorComAChave(indice)
    jogador.chaves = jogador.chaves + 1
    table.remove(objetos, indice)
end

function temColisao(objetoA, objetoB)
    local esquerdaDeA = objetoA.x - 8
    local direitaDeA = objetoA.x + 7
    local baixoDeA = objetoA.y + 7
    local cimaDeA = objetoA.y - 8

    local esquerdaDeB = objetoB.x - 8
    local direitaDeB = objetoB.x + 7
    local baixoDeB = objetoB.y + 7
    local cimaDeB = objetoB.y - 8

    if esquerdaDeB > direitaDeA or direitaDeB < esquerdaDeA or cimaDeA > baixoDeB or baixoDeA < cimaDeB then
        return false
    end
    return true
end

function fazColisaoDoJogadorComAPorta(indice)
    if jogador.chaves > 0 then
        jogador.chaves = jogador.chaves - 1
        table.remove(objetos, indice)
    end
end

function verificaColisaoComObjetos()
    for indice, objeto in pairs(objetos) do
        if temColisao(jogador, objeto) then
            if objeto.sprite == Constantes.SPRITE_CHAVE then
                fazColisaoDoJogadorComAChave(indice)
            elseif objeto.sprite == Constantes.SPRITE_PORTA then
                fazColisaoDoJogadorComAPorta(indice)
            end
        end
    end
end

function TIC()
    atualiza()
    verificaColisaoComObjetos()
    desenha()
end

function criaPorta(coluna, linha)
    local porta = {
        sprite = Constantes.SPRITE_PORTA,
        x = coluna * 8 + 8,
        y = linha * 8 + 8,
        corDeFundo = 2
    }
    return porta
end

function criaChave(coluna, linha)
    local chave = {
        sprite = Constantes.SPRITE_CHAVE,
        x = coluna * 8 + 8,
        y = linha * 8 + 8,
        corDeFundo = 2
    }
    return chave
end

function inicializa()
    chave = criaChave(3, 3)
    table.insert(objetos, chave)

    local porta = criaPorta(16, 7)
    table.insert(objetos, porta)
end

inicializa()
