# Plan de desarrollo por entregas

## Entrega 1.1: aventura lateral inspirada en metroidvanias

- [x] Cambiar el recorrido de arriba abajo por una sala lateral de plataformas.
- [x] Movimiento con aceleración, salto variable, gravedad diferenciada y coyote time.
- [x] Cámara horizontal con límites y composición de fondos en capas.
- [x] Enemigos de patrulla con daño, vida y ataque de pulso.
- [x] Estaciones de conversación para investigar y decidir sobre publicaciones.
- [x] Mapa de sala, HUD y ayuda con controles visibles.
- [ ] Desbloqueo de dash y rutas nuevas entre zonas conectadas por un grafo.
- [ ] Animaciones dibujadas y audio propios; ahora el avatar y efectos se dibujan con formas.

La guía suministrada se usa como referencia técnica de movimiento, legibilidad, cámara limitada, patrones de enemigos, exploración por habilidades y alcance incremental. La temática, personajes, nombres, visuales y retos de este juego son propios de Ciudad Nova.

## Entrega 1: árbol + experiencia base

- [x] Crear ciclo jugable con escena 2D y HUD.
- [x] Movimiento controlado y animación del avatar.
- [x] Implementar árbol y hacer que la acción del jugador determine su recorrido.
- [x] Mostrar el impacto de la decisión en indicadores.
- [ ] Completar operaciones de inserción/eliminación y justificar variante de árbol ante el equipo.
- [ ] Añadir clips/sonidos propios y una pantalla de resultados de partida.

## Entrega 2: grafos y propagación

- [x] Modelar relaciones sociales con lista de adyacencia.
- [x] Recorrer la red mediante BFS y usar alcance en la mecánica de compartir.
- [ ] Añadir grafo de zonas de Ciudad Nova y navegación entre ubicaciones.
- [ ] Representar difusión en pantalla paso a paso y calcular velocidad/turnos de propagación.
- [ ] Añadir operaciones del grafo y explicar su complejidad durante la sustentación.

## Entrega final

- [ ] Roles con habilidades diferenciadas para 2–4 personas.
- [ ] Servidor autoritativo con sockets y clientes sincronizados.
- [ ] Temporizador opcional en situaciones virales y eventos aleatorios equilibrados.
- [ ] Votación final influida por reputación, confianza, participación y conflictos.
- [ ] Alto contraste, escalado de interfaz y ajuste de movimiento/tiempo.
- [ ] Sonido, logros y transiciones al servicio de la retroalimentación.
- [ ] Manual de arquitectura, protocolo de red, guía de contribución y commits por integrante.
- [ ] Probar en computadoras del equipo y congelar una versión demostrable.

## Trabajo distribuido sugerido

1. **Mecánicas/datos:** árbol, grafo, propagación y eventos (`src/models.py`).
2. **Interfaz/experiencia:** escena, animaciones, accesibilidad y feedback (`src/game.py`).
3. **Red/calidad de entrega:** sockets, protocolo, persistencia de partida y documentación (`src/network/`, pendiente).

Antes de repartirse, acuerden nombres de métodos y eventos; integren por pull requests pequeños y mantengan el `main` ejecutable. El requisito de commits por integrante hace importante que cada estudiante trabaje desde su propia cuenta y firme cambios reales. El repo se creó localmente; una vez exista la URL de GitHub se añade el remoto y se publica.
