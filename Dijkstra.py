#Bibliotecas utilizadas no algoritmo
import heapq
import os
from consolemenu import *
from consolemenu.items import *

#Algoritmo de Dijkstra
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

#Grafo utilizado (AVISO: AS INFORMAÇÕES NÂO CONDIZEM COM A REALIDADE)
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

#Procedimento para limpar o console
def limpa_tela():
    os.system('cls')

#Procedimento para executar o algoritmo de Dijkstra e receber as informações necessarias para o funcionamento
def exe_com_dijkstra():
    op = 's'
    while op == 's':
        limpa_tela()
        partida = input(F"Informe qual a cidade de partida: ")
        chegada = input(F"Informe qual a cidade de destino: ")
        if partida not in grafo or chegada not in grafo:
            input('Cidades inválidas. Pressione Enter para inserir novamente')         
            continue
        limpa_tela()
        distancia, caminho = dijkstra(grafo, partida, chegada)
        caminho_lista = ' --> '.join(caminho)
        print(f"Distância mais curta de {partida} até {chegada}: {distancia}")
        print(f"Caminho: {caminho_lista}")
        input('Pressione Enter para continuar...')
        limpa_tela()
        op = input('Deseja fazer outra consulta? (S ou N): ')

#Procedimento com as informações gerais e avisos do algoritmo
def informacoes():
    print("Informações gerais: ")
    print("Este projeto foi desenvolvido por: William Wollert \n")
    print("AVISO: Os dados utilizados neste programa são FICTICIOS")
    print("Portanto não devem ser considerados para uso real \n")
    print("É possivel utilizar dados reais neste projeto?")
    print("Sim, é possivel, este projeto foi apenas uma demonstração do algoritmo de Dijkstra \n")
    input("Pressione Enter para continuar...")

#Procedimento para encerrar o algoritmo
def encerra_programa():
    print("Encerrando o programa...")
    exit(0)

#Menu visual utilizando o Console Menu
menu = ConsoleMenu("Menu Principal", "Escolha uma das opções abaixo:",show_exit_option=False)
menu.append_item(FunctionItem("Executar programa", exe_com_dijkstra))
menu.append_item(FunctionItem("Informações do programa", informacoes))
menu.append_item(FunctionItem("Encerrar programa", encerra_programa))
menu.show()