import heapq

def dijkstra(grafo, ini, fim):
    distancias = {no: float('infinity') for no in grafo}
    distancias[ini] = 0

    no_anterior = {no: None for no in grafo}

    prioridade = [(0, ini)]

    while prioridade:
        distancia_atual, no_atual = heapq.heappop(prioridade)

        if no_atual == fim:
            break

        if distancia_atual > distancias[no_atual]:
            continue

        for vizinho, peso in grafo[no_atual].items():
            distancia = distancia_atual + peso

            if distancia < distancias[vizinho]:
                distancias[vizinho] = distancia
                no_anterior[vizinho] = no_atual
                heapq.heappush(prioridade, (distancia, vizinho))

    caminho = []
    no_atual = fim
    while no_atual is not None:
        caminho.insert(0, no_atual)
        no_atual = no_anterior[no_atual]

    if distancias[fim] == float('infinity'):
        return (float('infinity'), [])

    return (distancias[fim], caminho)

grafo = {
    'rio do sul': {'taio':66,'aurora':132,'ituporanga':132,'agronomica':231,'mirim doce':363,'presidente getulio':231},
    'taio': {'rio do sul':66,'pouso redondo':90,'aurora':30,'ibirama':240,'laurentino':120},
    'aurora': {'taio':30,'rio do sul':132,'ituporanga':60,'santa teresinha':60},
    'ituporanga': {'rio do sul':132,'aurora':60,'santa teresinha':45,'salete':60},
    'pouso redondo': {'taio':90,'presidente getulio':55},
    'presidente getulio': {'pouso redondo':55,'laguna':66,'mirim doce':198,'rio do sul':231,'ibirama':231},
    'mirim doce': {'mirim doce':363,'presidente getulio':198,'agronomica':30},
    'agronomica':{'mirim doce':30,'rio do sul':231},
    'laguna':{'presidente getulio':66},
    'ibirama':{'presidente getulio':231,'taio':240},
    'laurentino':{'taio':120},
    'santa teresinha':{'aurora':60,'ituporanga':45,'atalanta':88},
    'atalanta':{'santa teresinha':88,'salete':140,'agrolandia':65},
    'salete':{'atalanta':140,'agrolandia':60,'ituporanga':60},
    'agrolandia':{'atalanta':65,'salete':60}
}

op = 'S'
while op == 'S':
    partida = input(F"Informe qual a cidade de partida: ")
    chegada = input(F"Informe qual a cidade de destino: ")
    distancia, caminho = dijkstra(grafo, partida, chegada)
    print(f"Distância mais curta de {partida} até {chegada}: {distancia}")
    print(f"Caminho: {caminho}")
    op = input('Deseja fazer outra consulta? (S ou N)')
