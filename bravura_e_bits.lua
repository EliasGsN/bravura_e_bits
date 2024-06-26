-- title:   Bravura & Bits 
-- author:  Elias
-- desc:    RPG de acao 2D
-- script:  lua
Constantes = {
    LARGURA_DA_TELA = 240,
    ALTURA_DA_TELA = 138,
    VELOCIDADE_ANIMACAO_JOGADOR = 0.1,

    SPRITE_INIMIGO = 292,
    SPRITE_CHAVE = 364,
    SPRITE_PORTA = 366,

    ID_SFX_CHAVE = 0,
    ID_SFX_PORTA = 1,

    INIMIGO = "INIMIGO",
    JOGADOR = "JOGADOR",

    Direcao = {
        CIMA = 1,
        BAIXO = 2,
        ESQUERDA = 3,
        DIREITA = 4
    }
}

objetos = {}

function temColisaoComMapa(ponto)
    local blocoX = ponto.x / 8
    local blocoY = ponto.y / 8
    local blocoId = mget(blocoX, blocoY)
    return blocoId >= 128
end

function moverPara(personagem, delta)
    local novaPosicao = {
        x = personagem.x + delta.deltaX,
        y = personagem.y + delta.deltaY
    }

    if verificaColisaoComObjetos(personagem, novaPosicao) then
        return
    end

    local superiorEsquerdo = {
        x = personagem.x - 8 + delta.deltaX,
        y = personagem.y - 8 + delta.deltaY
    }
    local superiorDireito = {
        x = personagem.x + 7 + delta.deltaX,
        y = personagem.y - 8 + delta.deltaY
    }
    local inferiorDireito = {
        x = personagem.x + 7 + delta.deltaX,
        y = personagem.y + 7 + delta.deltaY
    }
    local inferiorEsquerdo = {
        x = personagem.x - 8 + delta.deltaX,
        y = personagem.y + 7 + delta.deltaY
    }

    if not (temColisaoComMapa(superiorEsquerdo) or temColisaoComMapa(superiorDireito) or
        temColisaoComMapa(inferiorEsquerdo) or temColisaoComMapa(inferiorDireito)) then

        personagem.quadroDeAnimacao = personagem.quadroDeAnimacao + Constantes.VELOCIDADE_ANIMACAO_JOGADOR
        if personagem.quadroDeAnimacao >= 3 then
            personagem.quadroDeAnimacao = 1
        end

        personagem.y = personagem.y + delta.deltaY
        personagem.x = personagem.x + delta.deltaX
    end
end

function atualiza()
    local AnimacaoJogador = {{256, 258}, {260, 262}, {264, 266}, {268, 270}}

    local Direcao = {{
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

    for tecla = 0, 3 do
        if btn(tecla) then
            local quadros = AnimacaoJogador[tecla + 1]
            local quadro = math.floor(jogador.quadroDeAnimacao)
            jogador.sprite = quadros[quadro]

            moverPara(jogador, Direcao[tecla + 1])
        end
    end

    for _, objeto in pairs(objetos) do
        if objeto.tipo == Constantes.INIMIGO then
            atualizaInimigo(objeto)
        end
    end
end

function atualizaInimigo(inimigo)
    local delta = {
        deltaX = 0,
        deltaY = 0
    }

    if jogador.y > inimigo.y then
        delta.deltaY = 0.5
        inimigo.direcao = Constantes.Direcao.BAIXO
    elseif jogador.y < inimigo.y then
        delta.deltaY = -0.5
        inimigo.direcao = Constantes.Direcao.CIMA
    end
    moverPara(inimigo, delta)

    delta = {
        deltaX = 0,
        deltaY = 0
    }
    if jogador.x > inimigo.x then
        delta.deltaX = 0.5
        inimigo.direcao = Constantes.Direcao.DIREITA
    elseif jogador.x < inimigo.x then
        delta.deltaX = -0.5
        inimigo.direcao = Constantes.Direcao.ESQUERDA
    end
    moverPara(inimigo, delta)

    local AnimacaoInimigo = {{288, 290}, {292, 294}, {296, 298}, {300, 302}}

    local quadros = AnimacaoInimigo[inimigo.direcao]
    local quadro = math.floor(inimigo.quadroDeAnimacao)
    inimigo.sprite = quadros[quadro]
end

function verificaColisaoComObjetos(personagem, novaPosicao)
    for indice, objeto in pairs(objetos) do
        if temColisao(novaPosicao, objeto) then
            local funcaoDeColisao = objeto.colisoes[personagem.tipo]
            return funcaoDeColisao(indice)
        end
    end
    return false
end

function desenhaMapa()
    map(0, 0, Constantes.ALTURA_DA_TELA, Constantes.LARGURA_DA_TELA, 0, 0)
end

function desenhaJogador()
    spr(jogador.sprite, jogador.x - 8, jogador.y - 8, jogador.corDeFundo, 1, 0, 0, 2, 2)
end

function desenhaObjetos()
    for _, objeto in pairs(objetos) do
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
    sfx(Constantes.ID_SFX_CHAVE, 60, 32, 0, 8, 5)
    return false
end

function fazColisaoDoJogadorComAPorta(indice)
    if jogador.chaves > 0 then
        jogador.chaves = jogador.chaves - 1
        table.remove(objetos, indice)
        sfx(Constantes.ID_SFX_PORTA, 84, 32, 0, 8, 5)
        return false
    end
    return true
end

function fazColisaoDoInimigoComAPorta(indice)
    -- Implementa a lógica necessária para quando o inimigo colidir com a porta
    -- No momento, vamos apenas retornar falso para permitir a colisão
    return true
end

function fazColisaoDoJogadorComOInimigo(indice)
    inicializa()
    return true
end

function deixaPassar(indice)
    return false
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

    return not (esquerdaDeB > direitaDeA or direitaDeB < esquerdaDeA or cimaDeA > baixoDeB or baixoDeA < cimaDeB)
end

function criaPorta(coluna, linha)
    return {
        colisoes = {
            [Constantes.INIMIGO] = fazColisaoDoInimigoComAPorta,
            [Constantes.JOGADOR] = fazColisaoDoJogadorComAPorta
        },
        sprite = Constantes.SPRITE_PORTA,
        x = coluna * 8 + 8,
        y = linha * 8 + 8,
        corDeFundo = 2
    }
end

function criaChave(coluna, linha)
    return {
        colisoes = {
            [Constantes.INIMIGO] = deixaPassar,
            [Constantes.JOGADOR] = fazColisaoDoJogadorComAChave
        },
        sprite = Constantes.SPRITE_CHAVE,
        x = coluna * 8 + 8,
        y = linha * 8 + 8,
        corDeFundo = 2
    }
end

function criaInimigo(coluna, linha)
    return {
        colisoes = {
            [Constantes.INIMIGO] = deixaPassar,
            [Constantes.JOGADOR] = fazColisaoDoJogadorComOInimigo
        },
        tipo = Constantes.INIMIGO,
        sprite = Constantes.SPRITE_INIMIGO,
        x = coluna * 8 + 8,
        y = linha * 8 + 8,
        corDeFundo = 5,
        quadroDeAnimacao = 1,
        direcao = Constantes.Direcao.BAIXO
    }
end

function inicializa()
    objetos = {}

    local chave = criaChave(3, 2)
    table.insert(objetos, chave)

    local porta = criaPorta(16, 7)
    table.insert(objetos, porta)

    local inimigo = criaInimigo(20, 7)
    table.insert(objetos, inimigo)

    jogador = {
        tipo = Constantes.JOGADOR,
        sprite = 260,
        x = 24,
        y = 110,
        corDeFundo = 2,
        quadroDeAnimacao = 1,
        chaves = 0
    }
end

function TIC()
    atualiza()
    desenha()
end

inicializa()
