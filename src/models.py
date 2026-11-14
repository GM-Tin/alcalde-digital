"""Modelos y estructuras de datos centrales del juego."""

from dataclasses import dataclass, field
from collections import deque
from typing import Optional


@dataclass
class DecisionNode:
    label: str
    children: dict[str, "DecisionNode"] = field(default_factory=dict)


class DecisionTree:
    """Árbol de decisión recorrido por las opciones de una publicación."""

    def __init__(self) -> None:
        self.root = DecisionNode("publicación")
        self.root.children = {
            "verificar": DecisionNode("verificar", {
                "verdadera": DecisionNode("compartir"),
                "falsa": DecisionNode("reportar"),
            }),
            "compartir": DecisionNode("compartir"),
            "reportar": DecisionNode("reportar"),
            "ignorar": DecisionNode("ignorar"),
        }

    def traverse(self, action: str, verified: Optional[bool] = None) -> list[str]:
        """Devuelve la ruta tomada, incluyendo el resultado de verificar."""
        path = [self.root.label]
        node = self.root.children[action]
        path.append(node.label)
        if action == "verificar":
            outcome = "verdadera" if verified else "falsa"
            path.append(outcome)
            path.append(node.children[outcome].label)
        return path


class SocialGraph:
    """Grafo social no dirigido; BFS calcula alcance y propagación."""

    def __init__(self, edges: tuple[tuple[str, str], ...]) -> None:
        self.adjacency: dict[str, set[str]] = {}
        for a, b in edges:
            self.adjacency.setdefault(a, set()).add(b)
            self.adjacency.setdefault(b, set()).add(a)

    def reachable_from(self, start: str) -> list[str]:
        visited = {start}
        queue = deque([start])
        order = []
        while queue:
            current = queue.popleft()
            order.append(current)
            for neighbor in sorted(self.adjacency.get(current, ())):
                if neighbor not in visited:
                    visited.add(neighbor)
                    queue.append(neighbor)
        return order


@dataclass
class Publication:
    text: str
    true: bool
    source: str
    verified: Optional[bool] = None


@dataclass
class CityState:
    verified_info: int = 52
    trust: int = 55
    coexistence: int = 62
    digital_wellbeing: int = 60
    misinformation: int = 24
    conflicts: int = 18
    reputation: int = 0
    round_number: int = 1

    def change(self, **deltas: int) -> None:
        for key, delta in deltas.items():
            setattr(self, key, max(0, min(100, getattr(self, key) + delta)))


PUBLICATIONS = (
    Publication("El colegio cerrará mañana.", False, "Mensaje reenviado sin fuente"),
    Publication("La plaza tendrá una jornada de limpieza vecinal.", True, "Alcaldía de Ciudad Nova"),
    Publication("Un candidato quiere cerrar el parque del barrio.", False, "Captura recortada"),
    Publication("El debate municipal será el viernes a las 5.", True, "Calendario electoral oficial"),
    Publication("El alcalde actual está robando dinero.", False, "Rumor anónimo"),
)

SOCIAL_GRAPH = SocialGraph((
    ("Tú", "Ana"), ("Tú", "Luis"), ("Ana", "Pedro"),
    ("Luis", "Carlos"), ("Pedro", "María"), ("María", "Sofía"),
    ("Carlos", "Julián"), ("Sofía", "Valentina"),
))
