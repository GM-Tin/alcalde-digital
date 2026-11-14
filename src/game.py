"""Prototipo 2D cartoon de Alcalde Digital, implementado con Pygame."""

import random
import sys
import pygame

from .models import CityState, DecisionTree, PUBLICATIONS, SOCIAL_GRAPH, Publication

W, H = 1100, 720
BG = (238, 246, 240)
INK = (39, 54, 59)
MUTED = (103, 121, 122)
GREEN = (65, 161, 113)
BLUE = (74, 146, 207)
GOLD = (245, 188, 75)
RED = (222, 104, 94)
WHITE = (255, 255, 255)


class AlcaldeDigitalGame:
    def __init__(self) -> None:
        pygame.init()
        pygame.display.set_caption("Alcalde Digital · Ciudad Nova")
        self.screen = pygame.display.set_mode((W, H))
        self.clock = pygame.time.Clock()
        self.font = pygame.font.SysFont("segoeui,arial", 20)
        self.small = pygame.font.SysFont("segoeui,arial", 15)
        self.bold = pygame.font.SysFont("segoeui,arial", 25, bold=True)
        self.state = CityState()
        self.tree = DecisionTree()
        self.player = pygame.Rect(275, 390, 34, 48)
        self.face_right = True
        self.walk_frame = 0
        self.message = "Muévete por Ciudad Nova y ayuda a que la información llegue con cuidado."
        self.publication = self.new_publication()
        self.round_log: list[str] = []
        self.recent_reach = 0
        self.recent_event = ""
        self.show_help = False
        self.banner_time = 0
        self.running = True

    def text(self, value: str, x: int, y: int, color=INK, font=None) -> None:
        self.screen.blit((font or self.font).render(value, True, color), (x, y))

    @staticmethod
    def new_publication() -> Publication:
        source = random.choice(PUBLICATIONS)
        return Publication(source.text, source.true, source.source)

    def rounded(self, rect, color, radius=16, border=None):
        pygame.draw.rect(self.screen, color, rect, border_radius=radius)
        if border:
            pygame.draw.rect(self.screen, border, rect, 2, border_radius=radius)

    def draw_city(self) -> None:
        pygame.draw.rect(self.screen, (205, 232, 215), (0, 92, 728, 628))
        # Paths
        pygame.draw.rect(self.screen, (232, 218, 183), (0, 525, 728, 78))
        pygame.draw.rect(self.screen, (232, 218, 183), (430, 92, 78, 628))
        for x in range(20, 730, 52):
            pygame.draw.circle(self.screen, (251, 239, 205), (x, 564), 3)
        # Park and plaza
        self.rounded((25, 145, 210, 150), (143, 203, 145), 25)
        self.text("PARQUE", 86, 151, (43, 106, 69), self.small)
        for x, y in ((75, 220), (145, 250), (173, 205)):
            pygame.draw.rect(self.screen, (129, 91, 64), (x+12, y+14, 8, 28), border_radius=3)
            pygame.draw.circle(self.screen, (55, 151, 92), (x+16, y+9), 17)
        self.rounded((550, 118, 150, 130), (248, 221, 144), 22)
        self.text("PLAZA", 595, 128, (136, 100, 37), self.small)
        pygame.draw.circle(self.screen, (239, 177, 81), (625, 196), 25)
        # Buildings
        self.draw_building(250, 132, 150, 180, (244, 164, 130), "COLEGIO", "C")
        self.draw_building(540, 350, 155, 155, (155, 184, 226), "BARRIO", "B")
        self.draw_building(45, 365, 165, 130, (222, 167, 213), "CENTRO CÍVICO", "+")
        # Citizen nodes, illustrating the social graph
        positions = {"Ana": (290, 350), "Luis": (360, 450), "Pedro": (570, 320),
                     "Carlos": (225, 490), "María": (635, 300), "Sofía": (600, 430),
                     "Julián": (160, 320), "Valentina": (675, 470)}
        links = (("Ana", "Luis"), ("Ana", "Pedro"), ("Luis", "Carlos"),
                 ("Pedro", "María"), ("María", "Sofía"), ("Sofía", "Valentina"), ("Carlos", "Julián"))
        for a, b in links:
            pygame.draw.line(self.screen, (173, 199, 179), positions[a], positions[b], 2)
        for name, (x, y) in positions.items():
            pygame.draw.circle(self.screen, (255, 249, 226), (x, y), 16)
            pygame.draw.circle(self.screen, (117, 153, 122), (x, y), 16, 2)
            self.text(name, x-19, y+17, MUTED, self.small)
        self.draw_player()

    def draw_building(self, x, y, w, h, color, label, icon) -> None:
        self.rounded((x, y+25, w, h-25), color, 12)
        pygame.draw.polygon(self.screen, (91, 117, 133), ((x-8, y+31), (x+w/2, y), (x+w+8, y+31)))
        self.text(icon, x+w//2-12, y+45, WHITE, self.bold)
        self.text(label, x+12, y+h-25, (65, 77, 84), self.small)
        for wx in range(x+18, x+w-12, 36):
            pygame.draw.rect(self.screen, (255, 241, 190), (wx, y+88, 20, 24), border_radius=4)

    def draw_player(self) -> None:
        bob = (self.walk_frame % 2) * 2
        x, y = self.player.x, self.player.y + bob
        # Shadow, head, hair, body and feet: simple custom cartoon character.
        pygame.draw.ellipse(self.screen, (127, 160, 131), (x-3, y+41, 40, 9))
        pygame.draw.rect(self.screen, (61, 115, 173), (x+4, y+20, 27, 23), border_radius=9)
        pygame.draw.circle(self.screen, (231, 171, 119), (x+17, y+12), 13)
        pygame.draw.arc(self.screen, (72, 52, 42), (x+4, y-1, 27, 23), 3.15, 6.2, 5)
        eye_x = x+22 if self.face_right else x+12
        pygame.draw.circle(self.screen, INK, (eye_x, y+12), 2)
        pygame.draw.line(self.screen, (53, 73, 94), (x+10, y+42), (x+8, y+49), 4)
        pygame.draw.line(self.screen, (53, 73, 94), (x+26, y+42), (x+28, y+49), 4)

    def draw_bar(self, label, value, x, y, color) -> None:
        self.text(label, x, y, MUTED, self.small)
        self.rounded((x, y+22, 154, 11), (231, 237, 233), 6)
        self.rounded((x, y+22, int(154*value/100), 11), color, 6)
        self.text(str(value), x+160, y+15, INK, self.small)

    def draw_panel(self) -> None:
        pygame.draw.rect(self.screen, (250, 252, 250), (728, 0, 372, H))
        pygame.draw.line(self.screen, (222, 232, 226), (728, 0), (728, H), 2)
        self.text("ALCALDE DIGITAL", 754, 24, (44, 111, 81), self.bold)
        self.text("CIUDAD NOVA  ·  ELECCIÓN EN CURSO", 754, 59, MUTED, self.small)
        self.text(f"RONDA {self.state.round_number}", 754, 104, INK, self.bold)
        self.text("Pulso de la ciudad", 754, 143, MUTED, self.small)
        self.draw_bar("Información verificada", self.state.verified_info, 754, 168, BLUE)
        self.draw_bar("Confianza", self.state.trust, 754, 216, GREEN)
        self.draw_bar("Convivencia", self.state.coexistence, 754, 264, GOLD)
        self.draw_bar("Bienestar digital", self.state.digital_wellbeing, 754, 312, (132, 117, 199))
        self.draw_bar("Desinformación", self.state.misinformation, 754, 360, RED)
        self.draw_bar("Conflictos", self.state.conflicts, 754, 408, (216, 134, 93))
        self.rounded((750, 462, 326, 155), WHITE, 18, (225, 234, 228))
        self.text("PUBLICACIÓN DEL DÍA", 770, 478, MUTED, self.small)
        self.text_wrapped(self.publication.text, 770, 504, 288, INK, self.bold)
        self.text_wrapped(self.publication.source, 770, 538, 288, MUTED, self.small)
        actions = "Q Verificar   C Compartir   R Reportar   I Ignorar"
        self.text(actions, 758, 592, (63, 110, 87), self.small)
        self.text_wrapped(self.message, 758, 635, 320, INK, self.small)
        self.rounded((20, 16, 270, 52), (255, 255, 255), 18)
        self.text("Ciudad Nova · recorre y decide", 38, 31, (53, 100, 72), self.small)
        self.text("WASD / flechas: moverte   H: ayuda", 35, 672, MUTED, self.small)
        if self.show_help:
            self.draw_help()

    def text_wrapped(self, value, x, y, width, color, font) -> None:
        words, line, yy = value.split(), "", y
        for word in words:
            candidate = f"{line} {word}".strip()
            if font.size(candidate)[0] > width and line:
                self.text(line, x, yy, color, font)
                yy += font.get_linesize()
                line = word
            else:
                line = candidate
        if line:
            self.text(line, x, yy, color, font)

    def draw_help(self) -> None:
        shade = pygame.Surface((W, H), pygame.SRCALPHA)
        shade.fill((20, 38, 39, 165))
        self.screen.blit(shade, (0, 0))
        self.rounded((260, 170, 590, 380), WHITE, 26)
        self.text("¿Cómo se juega?", 302, 201, (44, 111, 81), self.bold)
        lines = ["Explora la ciudad con WASD o las flechas.",
                 "Q verifica: consulta la fuente y la veracidad.",
                 "Comparte solo después de verificar.",
                 "R reporta contenido falso; I lo ignora.",
                 "La difusión sigue las conexiones del vecindario.",
                 "Cuida confianza, convivencia y bienestar.",
                 "Pulsa H para cerrar esta ayuda."]
        for i, line in enumerate(lines):
            self.text("• " + line, 304, 249+i*35, INK, self.font)

    def decide(self, action: str) -> None:
        p = self.publication
        if action == "compartir" and p.verified is None:
            self.message = "Primero verifica la fuente con Q. Compartir sin revisar puede propagar un rumor."
            return
        route = self.tree.traverse(action, p.verified)
        if action == "verificar":
            p.verified = p.true
            if p.true:
                self.state.change(verified_info=7, trust=3, reputation=2)
                self.message = "¡Fuente confiable! La publicación coincide con información verificable."
            else:
                self.state.change(verified_info=3, trust=1, misinformation=-3)
                self.message = "La fuente no es confiable. Ya reconociste una señal de desinformación."
            self.round_log.append(" → ".join(route))
            return
        if action == "compartir":
            if p.true:
                recipients = SOCIAL_GRAPH.reachable_from("Tú")[1:]
                self.recent_reach = len(recipients)
                self.state.change(verified_info=4, trust=4, coexistence=2, reputation=4)
                self.message = f"Compartiste información verificada: llegó a {self.recent_reach} personas."
            else:
                self.recent_reach = len(SOCIAL_GRAPH.reachable_from("Tú")) - 1
                self.state.change(misinformation=10, conflicts=8, trust=-8, coexistence=-7,
                                  digital_wellbeing=-5, reputation=-5)
                self.message = f"El rumor llegó a {self.recent_reach} personas y elevó la tensión."
        elif action == "reportar":
            if p.true:
                self.state.change(trust=-2, conflicts=2)
                self.message = "La publicación era verdadera; un reporte incorrecto genera confusión."
            else:
                self.state.change(misinformation=-8, conflicts=-3, trust=4, reputation=3)
                self.message = "Reporte útil: se limita la circulación del rumor y mejora la convivencia."
        elif action == "ignorar":
            self.state.change(digital_wellbeing=2, conflicts=-1)
            self.message = "Decidiste no amplificarla. A veces una pausa ayuda a cuidar el bienestar."
        self.round_log.append(" → ".join(route))
        self.finish_round()

    def finish_round(self) -> None:
        if random.random() < 0.38:
            event = random.choice(("Una vecina inicia una campaña de convivencia digital.",
                                   "Una noticia local verdadera aparece en la plaza.",
                                   "Un rumor nuevo circula por el barrio.",
                                   "La discusión vecinal sube de tono."))
            self.recent_event = event
            if "convivencia" in event:
                self.state.change(coexistence=3, digital_wellbeing=2)
            elif "verdadera" in event:
                self.state.change(verified_info=2, trust=1)
            elif "rumor" in event.lower():
                self.state.change(misinformation=3)
            else:
                self.state.change(conflicts=2, coexistence=-1)
            self.message += " Evento: " + event
        self.state.round_number += 1
        self.publication = self.new_publication()

    def handle(self, event) -> None:
        if event.type == pygame.QUIT:
            self.running = False
        elif event.type == pygame.KEYDOWN:
            if event.key == pygame.K_ESCAPE:
                self.running = False
            elif event.key == pygame.K_h:
                self.show_help = not self.show_help
            elif not self.show_help:
                actions = {pygame.K_q: "verificar", pygame.K_c: "compartir",
                           pygame.K_r: "reportar", pygame.K_i: "ignorar"}
                if event.key in actions:
                    self.decide(actions[event.key])

    def update(self, dt: float) -> None:
        keys = pygame.key.get_pressed()
        dx = int(bool(keys[pygame.K_RIGHT] or keys[pygame.K_d])) - int(bool(keys[pygame.K_LEFT] or keys[pygame.K_a]))
        dy = int(bool(keys[pygame.K_DOWN] or keys[pygame.K_s])) - int(bool(keys[pygame.K_UP] or keys[pygame.K_w]))
        if dx or dy:
            self.walk_frame += 1
            self.face_right = dx >= 0 if dx else self.face_right
            self.player.x += round(dx * 220 * dt)
            self.player.y += round(dy * 220 * dt)
            self.player.clamp_ip(pygame.Rect(8, 112, 700, 590))

    def run(self) -> None:
        while self.running:
            dt = min(self.clock.tick(60) / 1000, 0.04)
            for event in pygame.event.get():
                self.handle(event)
            self.update(dt)
            self.screen.fill(BG)
            self.draw_city()
            self.draw_panel()
            pygame.display.flip()
        pygame.quit()
        sys.exit()
