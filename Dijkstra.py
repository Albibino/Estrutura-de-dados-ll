import heapq

def dijkstra(graph, start, end):
    distances = {node: float('infinity') for node in graph}
    distances[start] = 0

    previous_nodes = {node: None for node in graph}

    priority_queue = [(0, start)]

    while priority_queue:
        current_distance, current_node = heapq.heappop(priority_queue)

        if current_node == end:
            break

        if current_distance > distances[current_node]:
            continue

        for neighbor, weight in graph[current_node].items():
            distance = current_distance + weight

            if distance < distances[neighbor]:
                distances[neighbor] = distance
                previous_nodes[neighbor] = current_node
                heapq.heappush(priority_queue, (distance, neighbor))

    path = []
    current_node = end
    while current_node is not None:
        path.insert(0, current_node)
        current_node = previous_nodes[current_node]

    if distances[end] == float('infinity'):
        return (float('infinity'), [])

    return (distances[end], path)

graph = {
    'A': {'B': 1, 'C': 4},
    'B': {'A': 1, 'C': 2, 'D': 5},
    'C': {'A': 4, 'B': 2, 'D': 1},
    'D': {'B': 5, 'C': 1,'E':3},
    'E': {'D':3}
}

start_node = input(F"Informe qual a cidade de partida: ")
end_node = input(F"Informe qual a cidade de destino: ")
distance, path = dijkstra(graph, start_node, end_node)

print(f"Distância mais curta de {start_node} até {end_node}: {distance}")
print(f"Caminho: {path}")
