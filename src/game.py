"""Aventura lateral cartoon de Alcalde Digital: prototipo metroidvania educativo."""

import math
import random
import sys
from pathlib import Path
import pygame

from .models import CityState, DecisionTree, PUBLICATIONS, SOCIAL_GRAPH, Publication

W, H = 1100, 720
WORLD_W = 2780
SKY = (26, 39, 64)
INK = (29, 34, 47)
CREAM = (247, 239, 216)
MINT = (129, 205, 162)
GOLD = (250, 190, 91)
CORAL = (238, 109, 100)
BLUE = (115, 188, 230)


class AlcaldeDigitalGame:
    """Una sala lateral amplia: plataformas, cámara estable, NPCs y retos verificables."""

    def __init__(self) -> None:
        pygame.init()
        pygame.display.set_caption("Alcalde Digital · Rumores en Ciudad Nova")
        self.screen = pygame.display.set_mode((W, H))
        self.clock = pygame.time.Clock()
        self.font = pygame.font.SysFont("segoeui,arial", 20)
        self.small = pygame.font.SysFont("segoeui,arial", 16)
        self.bold = pygame.font.SysFont("segoeui,arial", 27, bold=True)
        self.state = CityState()
        self.asset_root = Path(__file__).resolve().parent.parent / "assets" / "vendor"
        self.player_animations = self.load_animation_sets()
        self.slime_frames = self.load_animation("mossy-cavern/Slimes/SlimeGreen", "SlimeBasic")
        self.boss_frames = self.load_boss_frames()
        self.plant_frames = self.load_animation("mossy-cavern/Plant Animations/Plant Animations/Plant 1", "Plant1")
        self.platform_art = self.load_platform_art()
        self.music_enabled = self.start_ambient_music()
        self.tree = DecisionTree()
        self.player = pygame.Rect(90, 516, 34, 52)
        self.vx = self.vy = 0.0
        self.facing = 1
        self.grounded = False
        self.coyote = self.jump_buffer = 0.0
        self.attack_timer = self.attack_cd = 0.0
        self.invulnerable = 0.0
        self.walk_time = self.camera = 0.0
        self.health = 5
        self.sparks: list[list[float]] = []
        self.platforms = [pygame.Rect(*p) for p in (
            (0, 574, 430, 160), (500, 574, 340, 160), (920, 574, 410, 160),
            (1410, 574, 450, 160), (1940, 574, 340, 160), (2370, 574, 410, 160),
            (205, 465, 145, 20), (610, 455, 130, 20), (1045, 452, 165, 20),
            (1540, 450, 145, 20), (2030, 453, 130, 20), (2500, 449, 160, 20),
            (355, 360, 115, 18), (810, 350, 115, 18), (1270, 355, 110, 18),
            (1775, 355, 110, 18), (2250, 355, 115, 18),
        )]
        self.terminals = [
            {"x": 292, "title": "Colegio", "done": False, "pub": Publication("El colegio cerrará mañana por una orden municipal.", False, "Mensaje reenviado sin enlace ni comunicado")},
            {"x": 1112, "title": "Plaza", "done": False, "pub": Publication("La jornada de limpieza será el sábado a las 9.", True, "Calendario publicado por la Alcaldía")},
            {"x": 1634, "title": "Centro cívico", "done": False, "pub": Publication("Un candidato eliminará el parque del barrio.", False, "Captura recortada, sin contexto")},
            {"x": 2580, "title": "Cabildo", "done": False, "pub": Publication("El debate público será el viernes a las 5.", True, "Agenda electoral oficial con fecha y lugar")},
        ]
        self.wisps = [{"x": 700.0, "home": 700.0, "dir": 1, "hp": 2, "flash": 0.0},
                      {"x": 1870.0, "home": 1870.0, "dir": -1, "hp": 2, "flash": 0.0},
                      {"x": 2320.0, "home": 2320.0, "dir": 1, "hp": 2, "flash": 0.0},
                      {"x": 2670.0, "home": 2670.0, "dir": -1, "hp": 5, "flash": 0.0, "boss": True}]
        self.message = "Explora Ciudad Nova. Habla con las personas y verifica antes de compartir."
        self.dialog: dict | None = None
        self.show_map = self.show_help = False
        self.round_log: list[str] = []
        self.recent_reach = 0
        self.running = True

    def load_animation(self, folder: str, prefix: str) -> list[pygame.Surface]:
        """Carga PNGs del paquete local y recorta márgenes transparentes enormes."""
        directory = self.asset_root / folder
        frames = []
        if not directory.exists():
            return frames
        for path in sorted(directory.glob(f"{prefix}*.png")):
            try:
                raw = pygame.image.load(str(path)).convert_alpha()
                bounds = raw.get_bounding_rect(min_alpha=12)
                if bounds.width and bounds.height:
                    frames.append(raw.subsurface(bounds).copy())
            except pygame.error:
                continue
        return frames

    def load_animation_sets(self) -> dict[str, list[pygame.Surface]]:
        base = "mossy-cavern/BlueWizard Animations/BlueWizard"
        return {
            "idle": self.load_animation(f"{base}/2BlueWizardIdle", "Chara - BlueIdle"),
            "walk": self.load_animation(f"{base}/2BlueWizardWalk", "Chara_BlueWalk"),
            "jump": self.load_animation(f"{base}/2BlueWizardJump", "CharaWizardJump_"),
        }

    def load_boss_frames(self) -> list[pygame.Surface]:
        path = self.asset_root / "zneeke-boss/Free Boss/dark fantasy big boss idle.png"
        try:
            sheet = pygame.image.load(str(path)).convert_alpha()
            return [sheet.subsurface(pygame.Rect(x, 0, 64, 64)).copy() for x in range(0, sheet.get_width(), 64)]
        except (pygame.error, ValueError):
            return []

    def load_platform_art(self) -> pygame.Surface | None:
        path = self.asset_root / "mossy-cavern/Mossy Assets/Mossy Tileset/Mossy - FloatingPlatforms.png"
        try:
            sheet = pygame.image.load(str(path)).convert_alpha()
            area = sheet.subsurface(pygame.Rect(440, 0, 1100, 500)).copy()
            bounds = area.get_bounding_rect(min_alpha=12)
            return area.subsurface(bounds).copy() if bounds.width and bounds.height else None
        except (pygame.error, ValueError):
            return None

    def start_ambient_music(self) -> bool:
        music = Path(__file__).resolve().parent.parent / "assets/audio/ciudad_nova_ambience.ogg"
        if not music.exists():
            music = self.asset_root / "music/Erased Places/drmseq_ErasedPlaces_OGG/Loops/drmseq_01_Moist_Walls_loop.ogg"
        try:
            pygame.mixer.init()
            if music.exists():
                pygame.mixer.music.load(str(music))
                pygame.mixer.music.set_volume(.24)
                pygame.mixer.music.play(-1)
                return True
        except pygame.error:
            pass
        return False

    def text(self, value: str, x: int, y: int, color=INK, font=None) -> None:
        self.screen.blit((font or self.font).render(value, True, color), (int(x), int(y)))

    def panel(self, rect, color, radius=15, border=None) -> None:
        pygame.draw.rect(self.screen, color, rect, border_radius=radius)
        if border:
            pygame.draw.rect(self.screen, border, rect, 2, border_radius=radius)

    def draw_background(self) -> None:
        self.screen.fill((16, 28, 42))
        # Parallax silhouettes create depth while keeping the walkable plane clear.
        for layer, (color, factor, base) in enumerate((((36, 52, 75), .12, 450), ((44, 67, 83), .25, 505))):
            offset = int(self.camera * factor)
            for i in range(-1, 7):
                x = i * 260 - offset % 260
                pygame.draw.polygon(self.screen, color, [(x, base), (x+70, base-95-layer*28),
                    (x+150, base-30), (x+220, base-130-layer*22), (x+280, base)])
        # Distant windows and stars.
        for i in range(46):
            x = (i * 137 - int(self.camera*.16)) % W
            y = 45 + (i*71) % 290
            pygame.draw.circle(self.screen, (117, 143, 164), (x, y), 1 + i % 2)
        for rect in self.platforms:
            view = rect.move(-int(self.camera), 0)
            if view.right < -10 or view.left > W+10:
                continue
            if self.platform_art:
                pygame.draw.rect(self.screen,(40,63,49),(view.x,view.y,view.w,view.h),border_radius=4)
                art_h = max(46, int(view.w*.41))
                art = pygame.transform.smoothscale(self.platform_art, (view.w, art_h))
                self.screen.blit(art, (view.x, view.y-int(art_h*.27)))
            else:
                pygame.draw.rect(self.screen, (19, 31, 38), (view.x, view.y+8, view.w, view.h), border_radius=5)
                pygame.draw.rect(self.screen, (47, 64, 60), view, border_radius=7)
                pygame.draw.rect(self.screen, (86, 143, 98), (view.x, view.y, view.w, 9), border_radius=4)
                for gx in range(view.x+16, view.right-4, 42):
                    pygame.draw.line(self.screen, (75, 102, 83), (gx, view.y+17), (gx+13, view.y+29), 2)
        # Civic-themed skyline and signposts.
        for x, label, col in ((50, "BARRIO", (75, 107, 133)), (980, "PLAZA", (101, 116, 121)),
                               (1470, "CENTRO CÍVICO", (94, 105, 131)), (2390, "CABILDO", (109, 105, 129))):
            sx = x - int(self.camera*.55)
            if -190 < sx < W+30:
                pygame.draw.rect(self.screen, col, (sx, 420, 172, 154), border_radius=12)
                pygame.draw.polygon(self.screen, (119, 132, 155), ((sx-12, 426), (sx+86, 362), (sx+184, 426)))
                for wx in (sx+24, sx+74, sx+124):
                    pygame.draw.rect(self.screen, (248, 206, 128), (wx, 450, 23, 29), border_radius=4)
                self.text(label, sx+10, 535, CREAM, self.small)

    def draw_terminal(self, node: dict) -> None:
        x = int(node["x"] - self.camera)
        if not -60 < x < W+60:
            return
        glow = GOLD if not node["done"] else MINT
        pygame.draw.ellipse(self.screen, (*glow, 48), (x-31, 506, 62, 80))
        pygame.draw.rect(self.screen, (45, 59, 76), (x-18, 486, 36, 76), border_radius=10)
        pygame.draw.rect(self.screen, glow, (x-12, 495, 24, 37), border_radius=6)
        pygame.draw.circle(self.screen, CREAM, (x, 513), 5)
        self.text("✓" if node["done"] else "!", x-7, 535, glow, self.bold)
        self.text(node["title"], x-35, 463, CREAM, self.small)

    def draw_player(self) -> None:
        x, y = self.player.x-self.camera, self.player.y
        moving = abs(self.vx) > 30 and self.grounded
        bob = math.sin(self.walk_time*17)*2 if moving else math.sin(pygame.time.get_ticks()/290)*1.5
        if self.invulnerable and int(self.invulnerable*18) % 2:
            return
        animation = self.player_animations["walk"] if moving else self.player_animations["jump"] if not self.grounded else self.player_animations["idle"]
        if animation:
            frame = animation[int(pygame.time.get_ticks() / (68 if moving else 110)) % len(animation)]
            height = 70 if moving or not self.grounded else 67
            scale = height / max(1, frame.get_height())
            sprite = pygame.transform.smoothscale(frame, (max(1, int(frame.get_width()*scale)), height))
            if self.facing < 0:
                sprite = pygame.transform.flip(sprite, True, False)
            self.screen.blit(sprite, (int(x+self.player.width/2-sprite.get_width()/2), int(y+self.player.height-sprite.get_height()+bob)))
            if self.attack_timer > 0:
                ax = x + (27 if self.facing > 0 else -31)
                pygame.draw.arc(self.screen, CREAM, (ax,y+8,42,43), -.9 if self.facing > 0 else 2.2, 1.0 if self.facing > 0 else 4.1, 4)
            return
        # Cape and legs animate independently for a readable cartoon silhouette.
        cape = [(x+8,y+24+bob),(x+28,y+26+bob),(x+34-self.facing*4,y+47+bob),(x+7,y+43+bob)]
        pygame.draw.polygon(self.screen, (229, 121, 83), cape)
        pygame.draw.ellipse(self.screen, (48, 69, 91), (x+7,y+20+bob,22,29))
        pygame.draw.circle(self.screen, (238, 193, 146), (int(x+17),int(y+14+bob)), 14)
        pygame.draw.arc(self.screen, (50, 43, 47), (x+3,y+1+bob,28,24), math.pi, math.tau, 6)
        eye = int(x+(22 if self.facing > 0 else 12))
        pygame.draw.circle(self.screen, INK, (eye,int(y+15+bob)), 2)
        step = math.sin(self.walk_time*17)*4 if moving else 0
        pygame.draw.line(self.screen, (39,50,68),(x+12,y+45+bob),(x+10-step,y+52),4)
        pygame.draw.line(self.screen, (39,50,68),(x+24,y+45+bob),(x+26+step,y+52),4)
        pygame.draw.ellipse(self.screen, (15,22,37), (x+2,y+51,34,7))
        if self.attack_timer > 0:
            ax = x + (30 if self.facing > 0 else -34)
            pygame.draw.arc(self.screen, CREAM, (ax,y+7,42,47), -.9 if self.facing > 0 else 2.2,
                            1.0 if self.facing > 0 else 4.1, 5)

    def draw_wisps(self, dt: float) -> None:
        for wisp in self.wisps:
            if wisp["hp"] <= 0:
                continue
            x = wisp["x"]-self.camera
            if not -55 < x < W+55:
                continue
            y = 537 + math.sin(pygame.time.get_ticks()/210+wisp["home"])*8
            if wisp.get("boss") and self.boss_frames:
                frame = self.boss_frames[int(pygame.time.get_ticks()/125) % len(self.boss_frames)]
                sprite = pygame.transform.scale(frame, (96, 96))
                self.screen.blit(sprite, (int(x-48), int(555-96)))
                self.text("GUARDIÁN DEL RUMOR",x-72,458,(224,171,129),self.small)
                pygame.draw.rect(self.screen,(44,30,37),(x-35,474,70,6),border_radius=3)
                pygame.draw.rect(self.screen,CORAL,(x-35,474,int(70*wisp["hp"]/5),6),border_radius=3)
            elif self.slime_frames:
                frame = self.slime_frames[int(pygame.time.get_ticks()/95+wisp["home"]) % len(self.slime_frames)]
                self.screen.blit(pygame.transform.smoothscale(frame, (58, 48)), (int(x-29), int(y-24)))
                if wisp["flash"] > 0:
                    tint = pygame.Surface((58,48), pygame.SRCALPHA); tint.fill((255,255,255,110)); self.screen.blit(tint,(int(x-29),int(y-24)))
            else:
                color = CREAM if wisp["flash"] > 0 else (178, 120, 205)
                pygame.draw.circle(self.screen,(81,64,111),(int(x),int(y)),23)
                pygame.draw.circle(self.screen,color,(int(x),int(y-2)),16)
                pygame.draw.circle(self.screen,INK,(int(x-5),int(y-4)),3)
                pygame.draw.circle(self.screen,INK,(int(x+5),int(y-4)),3)
                pygame.draw.arc(self.screen,INK,(x-6,y+1,12,9),0,math.pi,2)
            self.text("RUMOR",x-25,y-39,CORAL,self.small)
            wisp["flash"] = max(0,wisp["flash"]-dt)

    def draw_hud(self) -> None:
        self.panel((22,18,480,67),(17,27,44),18,(68,83,104))
        self.text("CIUDAD NOVA",42,27,CREAM,self.bold)
        self.text("GUARDIÁN DE LA INFORMACIÓN",44,58,(166,190,199),self.small)
        for i in range(5):
            pygame.draw.circle(self.screen,CORAL if i < self.health else (87,77,91),(458+i*23,43),8)
        self.panel((W-282,18,260,62),(17,27,44),16,(68,83,104))
        self.text(f"Datos verificados  {self.state.verified_info:02}",W-264,27,BLUE,self.small)
        self.text(f"Confianza  {self.state.trust:02}    Rumores  {self.state.misinformation:02}",W-264,53,CREAM,self.small)
        self.panel((24,H-62,612,40),(17,27,44),13,(68,83,104))
        self.text("A/D o ←→ mover   ESPACIO saltar   X pulso   E conversar   M mapa   H ayuda",38,H-52,CREAM,self.small)
        nearest = next((n for n in self.terminals if abs(n["x"]-self.player.centerx)<90 and not n["done"]),None)
        if nearest and self.dialog is None:
            self.panel((W//2-142,H-119,284,42),(249,222,160),13)
            self.text("E  ·  Investigar publicación",W//2-119,H-108,INK,self.small)
        if self.message and self.dialog is None:
            self.text(self.message[:92],25,101,(221,229,231),self.small)

    def draw_dialog(self) -> None:
        if not self.dialog:
            return
        shade=pygame.Surface((W,H),pygame.SRCALPHA); shade.fill((8,12,24,175)); self.screen.blit(shade,(0,0))
        self.panel((150,177,800,383),(246,240,221),25,(250,190,91))
        node=self.dialog
        self.text(node["title"],190,205,(49,105,86),self.bold)
        self.text("PUBLICACIÓN",190,252,(93,105,111),self.small)
        self.text_wrapped(node["pub"].text,190,280,715,INK,self.bold)
        self.text_wrapped("Fuente: "+node["pub"].source,190,348,715,(83,100,108),self.small)
        lines=["V  Verificar la fuente", "C  Compartir (después de verificar)",
               "R  Reportar si es falsa", "I  Ignorar y no amplificar", "ESC  Cerrar"]
        for i,line in enumerate(lines):
            self.text(line,197,405+i*27,(50,86,87),self.small)
        if self.message:
            self.text_wrapped(self.message,525,418,375,(111,82,42),self.small)

    def text_wrapped(self,value,x,y,width,color,font):
        line=""
        for word in value.split():
            candidate=(line+" "+word).strip()
            if font.size(candidate)[0]>width and line:
                self.text(line,x,y,color,font); y+=font.get_linesize()+3; line=word
            else: line=candidate
        if line: self.text(line,x,y,color,font)

    def draw_map(self):
        shade=pygame.Surface((W,H),pygame.SRCALPHA); shade.fill((8,12,24,200)); self.screen.blit(shade,(0,0))
        self.panel((145,170,810,365),(246,240,221),24,(115,188,230))
        self.text("MAPA DE CIUDAD NOVA",190,198,(49,105,86),self.bold)
        pygame.draw.line(self.screen,(120,144,139),(230,359),(858,359),6)
        for n in self.terminals:
            x=230+int(n["x"]/WORLD_W*628)
            pygame.draw.circle(self.screen,MINT if n["done"] else GOLD,(x,359),16)
            self.text(n["title"],x-33,390,(49,62,69),self.small)
        px=230+int(self.player.centerx/WORLD_W*628)
        pygame.draw.polygon(self.screen,CORAL,((px,327),(px-10,344),(px+10,344)))
        self.text("Las estaciones con luz contienen una conversación y una decisión.",195,450,(65,81,86),self.small)
        self.text("M o ESC para volver",195,489,(65,81,86),self.small)

    def draw_help(self):
        shade=pygame.Surface((W,H),pygame.SRCALPHA); shade.fill((8,12,24,205)); self.screen.blit(shade,(0,0))
        self.panel((190,160,720,400),(246,240,221),24,(115,188,230))
        self.text("AVENTURA Y CIUDADANÍA DIGITAL",230,191,(49,105,86),self.bold)
        help_lines=["Recorre plataformas y conversa en las cuatro estaciones.",
        "Verifica la fuente y el contexto antes de compartir.",
        "Los rumores son ecos: pulsa X para dispersarlos.",
        "Mover: A/D o flechas   ·   Saltar: Espacio", "Investigar: E   ·   Pulso: X   ·   Mapa: M",
        "Decisiones: V verificar · C compartir · R reportar · I ignorar", "H o ESC para cerrar"]
        for i,line in enumerate(help_lines): self.text(line,234,246+i*37,INK,self.small)

    def move_player(self,dt:float):
        keys=pygame.key.get_pressed()
        direction=int(keys[pygame.K_RIGHT] or keys[pygame.K_d])-int(keys[pygame.K_LEFT] or keys[pygame.K_a])
        if direction: self.facing=direction
        target=direction*285
        blend=min(1,16*dt) if direction else min(1,20*dt)
        self.vx += (target-self.vx)*blend
        if self.grounded: self.coyote=.105
        else: self.coyote=max(0,self.coyote-dt)
        self.jump_buffer=max(0,self.jump_buffer-dt)
        if self.jump_buffer>0 and self.coyote>0:
            self.vy=-565; self.grounded=False; self.coyote=0; self.jump_buffer=0
        if not keys[pygame.K_SPACE] and self.vy < -170: self.vy *= .88
        self.vy=min(920,self.vy+(1430 if self.vy<0 else 2180)*dt)
        self.player.x+=round(self.vx*dt)
        self.player.x=max(0,min(WORLD_W-self.player.width,self.player.x))
        for p in self.platforms:
            if self.player.colliderect(p):
                if self.vx>0: self.player.right=p.left
                elif self.vx<0: self.player.left=p.right
                self.vx=0
        old_bottom=self.player.bottom
        self.player.y+=round(self.vy*dt); self.grounded=False
        for p in self.platforms:
            if self.player.colliderect(p) and self.vy>=0 and old_bottom<=p.top+8:
                self.player.bottom=p.top; self.vy=0; self.grounded=True
        if self.player.top>H+150: self.player.topleft=(max(24,self.player.x-80),500); self.vy=0; self.health=max(1,self.health-1)
        if abs(self.vx)>35 and self.grounded: self.walk_time+=dt
        self.attack_cd=max(0,self.attack_cd-dt); self.attack_timer=max(0,self.attack_timer-dt)
        self.invulnerable=max(0,self.invulnerable-dt)
        self.camera=max(0,min(WORLD_W-W,self.player.centerx-W*.39))
        for w in self.wisps:
            if w["hp"]<=0: continue
            w["x"]+=w["dir"]*48*dt
            if abs(w["x"]-w["home"])>75: w["dir"]*=-1
            enemy=pygame.Rect(w["x"]-18,515,36,50)
            if self.player.colliderect(enemy) and not self.invulnerable:
                self.health=max(0,self.health-1); self.invulnerable=1.1
                self.vx=-self.facing*220; self.vy=-250
        self.sparks=[[x+vx*dt,y+vy*dt,vx,vy-dt*60,t-dt] for x,y,vx,vy,t in self.sparks if t>dt]

    def attack(self):
        if self.attack_cd>0: return
        self.attack_cd=.36; self.attack_timer=.15
        hit=pygame.Rect(self.player.right if self.facing>0 else self.player.left-62,self.player.y+10,62,38)
        hit=hit.move(-self.player.x if False else 0,0)
        for w in self.wisps:
            if w["hp"]>0 and hit.colliderect(pygame.Rect(w["x"]-22,514,44,47)):
                w["hp"]-=1; w["flash"]=.18
                for _ in range(9): self.sparks.append([w["x"],535,random.uniform(-150,150),random.uniform(-220,-40),.35])
                if w["hp"]<=0:
                    self.state.change(misinformation=-3,trust=1,digital_wellbeing=1)
                    self.message="Eco dispersado: contrastar y no amplificar reduce su alcance."

    def interact(self):
        node=min(self.terminals,key=lambda n:abs(n["x"]-self.player.centerx))
        if abs(node["x"]-self.player.centerx)<100:
            if node["done"]: self.message="Ya investigaste esta publicación; explora hacia la siguiente luz."
            else:
                self.dialog=node; node["pub"].verified=None
                self.message="Compara la fuente y el contexto antes de decidir."
        else: self.message="Acércate a una estación iluminada para investigar."

    def decide(self,action:str):
        node=self.dialog
        if not node: return
        p=node["pub"]
        if action=="compartir" and p.verified is None:
            self.message="Primero verifica la fuente (V). Compartir sin revisar propaga el rumor."; return
        route=self.tree.traverse(action,p.verified); self.round_log.append(" → ".join(route))
        if action=="verificar":
            p.verified=p.true
            if p.true:
                self.state.change(verified_info=8,trust=3,reputation=2)
                self.message="Fuente y contexto coinciden: la información es verificable."
            else:
                self.state.change(verified_info=4,trust=1,misinformation=-2)
                self.message="No hay evidencia confiable: identificaste una señal de desinformación."
            return
        if action=="compartir":
            if p.true:
                self.recent_reach=len(SOCIAL_GRAPH.reachable_from("Tú"))-1
                self.state.change(verified_info=4,trust=4,coexistence=2,reputation=3)
                self.message=f"Compartiste con cuidado; la red educativa alcanzaría {self.recent_reach} personas."
            else:
                self.recent_reach=len(SOCIAL_GRAPH.reachable_from("Tú"))-1
                self.state.change(misinformation=10,conflicts=7,trust=-7,coexistence=-5,digital_wellbeing=-4)
                self.message=f"El rumor podría llegar a {self.recent_reach} personas. Revisa antes de amplificar."
        elif action=="reportar":
            if p.true:
                self.state.change(trust=-2,conflicts=2); self.message="Era información verdadera; el reporte equivocado confunde."
            else:
                self.state.change(misinformation=-8,conflicts=-3,trust=4,reputation=3)
                self.message="Reporte útil: disminuye el alcance y se protege la convivencia."
        elif action=="ignorar":
            self.state.change(digital_wellbeing=2,conflicts=-1); self.message="Pausar también evita amplificar."
        node["done"]=True; self.state.round_number+=1

    def handle(self,event):
        if event.type==pygame.QUIT: self.running=False
        elif event.type==pygame.KEYDOWN:
            if event.key==pygame.K_ESCAPE:
                if self.dialog: self.dialog=None
                else: self.show_help=self.show_map=False
            elif self.dialog:
                choices={pygame.K_v:"verificar",pygame.K_c:"compartir",pygame.K_r:"reportar",pygame.K_i:"ignorar"}
                if event.key in choices: self.decide(choices[event.key])
            elif event.key==pygame.K_SPACE: self.jump_buffer=.12
            elif event.key in (pygame.K_x,pygame.K_j): self.attack()
            elif event.key==pygame.K_e: self.interact()
            elif event.key==pygame.K_m: self.show_map=not self.show_map
            elif event.key==pygame.K_h: self.show_help=not self.show_help

    def draw(self,dt):
        self.draw_background()
        for i, world_x in enumerate((165, 530, 875, 1365, 1885, 2310, 2710)):
            if self.plant_frames:
                frame = self.plant_frames[int(pygame.time.get_ticks()/135 + i*8) % len(self.plant_frames)]
                scale = 54 / max(1, frame.get_height())
                plant = pygame.transform.smoothscale(frame, (max(1,int(frame.get_width()*scale)),54))
                sx = int(world_x-self.camera)
                if -plant.get_width() < sx < W:
                    self.screen.blit(plant,(sx,574-plant.get_height()+9))
        for n in self.terminals: self.draw_terminal(n)
        self.draw_wisps(dt)
        # Firefly motes, drawn in screen space for a gentle animated atmosphere.
        for i in range(18):
            x=(i*83-int(self.camera*.7))%W; y=190+(i*59+int(pygame.time.get_ticks()*.025))%335
            pygame.draw.circle(self.screen,(128,173,164),(x,y),2)
        self.draw_player(); self.draw_hud()
        for x,y,_,_,_ in self.sparks: pygame.draw.circle(self.screen,GOLD,(int(x-self.camera),int(y)),3)
        if self.dialog: self.draw_dialog()
        if self.show_map: self.draw_map()
        if self.show_help: self.draw_help()
        pygame.display.flip()

    def run(self):
        while self.running:
            dt=min(self.clock.tick(60)/1000,.04)
            for event in pygame.event.get(): self.handle(event)
            if not self.dialog and not self.show_map and not self.show_help: self.move_player(dt)
            self.draw(dt)
        pygame.quit(); sys.exit()
