# Lectura del laboratorio y trazabilidad

## Identificación

El PDF adjunto es el enunciado **“Laboratorio — Alcalde Digital”** de Estructura de Datos II, Universidad del Norte. El juego trata sobre uso responsable de redes sociales durante una elección en Ciudad Nova. La entrada del chat del usuario solicita investigación de patrones de juegos cartoon interactivos, una experiencia con movimiento animado y una interfaz más rica; el contenido pedagógico y los requisitos técnicos de abajo provienen del enunciado.

## Requisitos funcionales del enunciado

1. **Propósito y narrativa:** decisiones sobre publicaciones verdaderas, opiniones y falsedades; consecuencias en reputación, confianza, convivencia, bienestar y desinformación.
2. **Roles:** participación de 2 a 4 jugadores y roles ciudadano, periodista, influencer y candidato a alcalde, con habilidades distintas.
3. **Árbol:** clasificación/jerarquía de publicaciones, decisiones y consecuencias; justificar variante, operaciones, recorrido e inserción/eliminación.
4. **Grafos:** grafo de lugares y grafo social; implementar operaciones y conectar el grafo a la propagación de contenidos.
5. **Propagación:** calcular destinatarios, cantidad, velocidad o recorrido y consecuencias; relacionarla con la experiencia de juego.
6. **Azar y habilidad:** eventos aleatorios cuyo resultado varía, más decisiones que respondan a la habilidad del jugador; algunas pueden tener límite de tiempo.
7. **Estado y puntuación:** indicadores dinámicos, puntos/reputación individual, resultado general y retroalimentación.
8. **Elección:** el comportamiento de la partida debe influir en la elección final del alcalde.
9. **Multijugador final:** modo local cliente-servidor, preferiblemente sockets; sincronizar partida, jugadores, publicaciones, relaciones, eventos, puntos, turnos y contenido compartido.
10. **GUI:** mostrar ciudad, personaje, publicaciones, opciones, estado, puntuación, indicadores y resultado de acciones; no basta una aplicación de consola.
11. **Inclusión:** al menos una función inclusiva explicada (por ejemplo, alto contraste, filtros de daltonismo, subtítulos o indicaciones visuales).
12. **Ayuda y motivación:** sección de ayuda con objetivo, reglas, botones, personajes, victoria e indicadores; sonidos, animaciones, logros, recompensas o cambios visuales integrados en la experiencia.
13. **Entrega y equipo:** tres entregas; Git con historial de commits por integrante; sustentación grupal. El lenguaje permitido está indicado como **Java o Python**.

## Hitos que el documento evalúa

- Primera entrega, semana 8: árboles pertinentes y operativos, recorridos, GUI preliminar y relación del árbol con la lógica.
- Segunda entrega, semana 12: grafos, operaciones, integración con árboles y mecánica, y visualización del grafo.
- Entrega final, semana 16: árbol, grafo, interfaz, azar, inclusión, ayuda, motivación, multijugador cliente-servidor y funcionamiento estable.

El PDF fecha la entrega final entre el 16 y 20 de noviembre de 2026 y la feria Gamer para el 26 de noviembre de 2026. Son fechas transcritas del archivo del curso, no confirmaciones externas.

## Trazabilidad de esta primera versión

| Requisito | Estado en la entrega inicial |
|---|---|
| Python permitido | Implementación Python + Pygame |
| GUI 2D cartoon | Ciudad dibujada con formas, zonas, personajes y panel de indicadores |
| Control del personaje | WASD/flechas, movimiento limitado al mapa, animación de pasos |
| Árbol funcional | Árbol de decisiones y recorrido guardado al actuar |
| Grafo social | Grafo de relaciones; BFS calcula personas alcanzables al compartir |
| Decisiones y consecuencias | Verificar, compartir verificado, reportar o ignorar; cambia estado de ciudad |
| Aleatoriedad | Publicaciones y eventos aleatorios |
| Ayuda | Ventana integrada con objetivo y controles |
| Roles 2–4 | Pendiente; esta versión es individual |
| Grafo de lugares | Pendiente; la ciudad ya dibuja ubicaciones como base visual |
| Tiempo limitado / habilidades | Pendiente |
| Elección de alcalde | Pendiente |
| Accesibilidad configurable | Pendiente (la ayuda y etiquetas ya acompañan visualmente) |
| Cliente-servidor por sockets | Pendiente para entrega final |
| Repo GitHub distribuido | Estructura y Git local listos; falta URL/remoto y commits de cada integrante |

## Observación de consistencia

El laboratorio requiere varias personas/roles y sincronización de red, pero la experiencia debe ser jugable también en una sola máquina. Conviene conservar un modo local de práctica y añadir después sesiones cliente-servidor. Los anuncios interactivos se usan aquí solo como referencia de diseño: el producto es un juego educativo, sin anuncios, tienda, CTA comercial ni analítica dirigida a niños.
