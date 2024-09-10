import heapq

def dijkstra(graph, start):
    # Dicionário para armazenar a menor distância de cada nó
    distances = {node: float('infinity') for node in graph}
    distances[start] = 0

    # Fila de prioridade para processar os nós
    priority_queue = [(0, start)]  # (distância, nó)

    while priority_queue:
        current_distance, current_node = heapq.heappop(priority_queue)

        # Se a distância do nó já for maior, não precisamos processá-lo
        if current_distance > distances[current_node]:
            continue

        # Verificando os vizinhos do nó atual
        for neighbor, weight in graph[current_node].items():
            distance = current_distance + weight

            # Se encontrarmos um caminho mais curto para o vizinho
            if distance < distances[neighbor]:
                distances[neighbor] = distance
                heapq.heappush(priority_queue, (distance, neighbor))

    return distances

# Exemplo de uso:
graph = {
    'Rio do Sul': {'B': 1, 'C': 4},
    'B': {'A': 1, 'C': 2, 'D': 5},
    'C': {'A': 4, 'B': 2, 'D': 1},
    'D': {'B': 5, 'C': 1}
}

start_node = 'A'
shortest_paths = dijkstra(graph, start_node)

print(f"Distâncias a partir do nó {start_node}: {shortest_paths}")
