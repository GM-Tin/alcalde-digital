"""Aventura lateral cartoon de Alcalde Digital: prototipo metroidvania educativo."""

import math
import random
import sys
from pathlib import Path
import pygame

from .models import CityState, DecisionTree, PUBLICATIONS, SOCIAL_GRAPH, Publication

W, H = 1100, 720
ZONE_W = 1850
WORLD_W = ZONE_W * 3
ZONE_NAMES = ("Bosque de los Ecos", "Barrio de Cristal", "Observatorio Celeste")
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
        self.boss_walk_frames = self.load_boss_frames("walk")
        self.plant_frames = self.load_animation("mossy-cavern/Plant Animations/Plant Animations/Plant 1", "Plant1")
        self.platform_art = self.load_platform_art()
        self.background_layers = self.load_background_layers()
        self.ground_art = self.load_ground_art()
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
            # Zona 1: saltos escalonados sobre plataformas de musgo.
            (0,574,610,180),(660,574,600,180),(1310,574,510,180),
            (150,466,180,20),(700,452,190,20),(1230,454,175,20),(1600,448,160,20),
            (420,354,115,18),(975,344,130,18),(1505,350,115,18),
            # Zona 2: columnas y terrazas de cristal.
            (1850,574,550,180),(2450,574,550,180),(3050,574,570,180),
            (1940,454,165,20),(2500,439,180,20),(3050,454,170,20),(3380,442,185,20),
            (2190,352,125,18),(2740,330,125,18),(3280,345,120,18),
            # Zona 3: islotes más altos y puentes del observatorio.
            (3700,574,580,180),(4330,574,580,180),(4960,574,590,180),
            (3790,454,180,20),(4380,440,170,20),(4890,432,185,20),(5290,450,170,20),
            (4050,348,125,18),(4610,328,130,18),(5140,346,125,18),
        )]
        pub_data = (
            ("El colegio cerrará mañana por una orden municipal.", False, "Mensaje reenviado sin enlace ni comunicado"),
            ("La jornada de limpieza será el sábado a las 9.", True, "Calendario publicado por la Alcaldía"),
            ("Un candidato eliminará el parque del barrio.", False, "Captura recortada, sin contexto"),
            ("El debate público será el viernes a las 5.", True, "Agenda electoral oficial con fecha y lugar"),
            ("El nuevo puente abrirá hoy a medianoche; comparte antes de que lo borren.", False, "Audio anónimo sin fecha ni fuente primaria"),
            ("La biblioteca móvil visitará el barrio el miércoles.", True, "Agenda pública con fecha y recorrido"),
        )
        positions = (300, 1110, 2110, 3160, 4100, 5140)
        challenge_types = ("math", "source", "tic", "math", "source", "tic")
        self.terminals = [
            {"x": x, "done": False, "unlocked": False, "challenge": kind,
             "pub": Publication(*pub)}
            for x, kind, pub in zip(positions, challenge_types, pub_data)
        ]
        self.wisps = [
            {"x":x,"home":x,"dir":direction,"hp":2,"flash":0.0}
            for x,direction in ((760,1),(1580,-1),(2310,1),(3420,-1),(4510,1),(5010,-1))
        ] + [{"x":5410.0,"home":5410.0,"dir":-1,"hp":8,"flash":0.0,"boss":True}]
        self.message = "Explora Ciudad Nova. Habla con las personas y verifica antes de compartir."
        self.dialog: dict | None = None
        self.challenge_node: dict | None = None
        self.challenge_feedback = ""
        self.tic_board: list[str] = [""] * 9
        self.tic_turn = "X"
        self.challenge_options: list[str] = []
        self.challenge_answer = 0
        self.active_zone = 0
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

    def load_boss_frames(self, animation: str = "idle") -> list[pygame.Surface]:
        path = self.asset_root / f"zneeke-boss/Free Boss/dark fantasy big boss {animation}.png"
        try:
            sheet = pygame.image.load(str(path)).convert_alpha()
            frames = []
            for x in range(0, sheet.get_width(), 64):
                frame = sheet.subsurface(pygame.Rect(x, 0, 64, 64)).copy()
                bounds = frame.get_bounding_rect(min_alpha=8)
                if bounds.width and bounds.height:
                    frame = frame.subsurface(bounds).copy()
                    # El sprite original es casi una silueta negra: darle luz violeta
                    # y ojos visibles para separarlo del fondo del observatorio.
                    frame.fill((75,42,115,0),special_flags=pygame.BLEND_RGBA_ADD)
                    frames.append(frame)
            return frames
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

    def load_background_layers(self) -> list[tuple[pygame.Surface, float]]:
        """Capas pintadas del bosque; el factor menor se mueve más despacio."""
        root = Path(__file__).resolve().parent.parent / "assets/art/digitalmoons/source/Parallax Forest Background (Seamless)/Parallax Forest Background - Blue"
        names = ("10_Sky", "09_Forest", "08_Forest", "07_Forest", "06_Forest",
                 "05_Particles", "04_Forest", "03_Particles", "02_Bushes", "01_Mist")
        # Dibujamos de atrás hacia adelante; las capas originales son 1920x1080.
        factors = (.015, .025, .04, .06, .085, .11, .14, .18, .23, .28)
        layers = []
        for name, factor in zip(names, factors):
            path = root / f"{name}.png"
            try:
                image = pygame.image.load(str(path)).convert_alpha()
                image = pygame.transform.smoothscale(image, (1280, 720))
                if name == "01_Mist":
                    image.set_alpha(145)
                layers.append((image, factor))
            except (pygame.error, OSError):
                continue
        return layers

    def load_ground_art(self) -> pygame.Surface | None:
        """Arte de suelo del paquete Mossy Cavern ya usado por el resto del juego."""
        path = self.asset_root / "mossy-cavern/Mossy Assets/Mossy Tileset/Mossy - FloatingPlatforms.png"
        try:
            sheet = pygame.image.load(str(path)).convert_alpha()
            area = sheet.subsurface(pygame.Rect(440, 0, 1100, 500)).copy()
            bounds = area.get_bounding_rect(min_alpha=12)
            if not bounds.width or not bounds.height:
                return None
            platform = area.subsurface(bounds).copy()
            # Solo la corona vegetal; no usamos el interior negro de la isla.
            cap = pygame.Rect(0, 0, platform.get_width(), min(155, platform.get_height()))
            cap_art = platform.subsurface(cap).copy()
            cap_bounds = cap_art.get_bounding_rect(min_alpha=12)
            return cap_art.subsurface(cap_bounds).copy() if cap_bounds.width and cap_bounds.height else None
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
        zone = min(2, int((self.camera + W*.45) // ZONE_W))
        self.active_zone = zone
        palettes = (
            ((16,28,42),(38,57,72),(48,76,77),(125,184,140)),
            ((19,25,49),(46,53,87),(65,78,112),(130,211,230)),
            ((23,22,48),(54,45,87),(81,66,118),(205,163,245)),
        )
        sky, far, near, accent = palettes[zone]
        self.screen.fill(sky)
        if self.background_layers:
            for image, factor in self.background_layers:
                offset = int(self.camera * factor) % image.get_width()
                self.screen.blit(image, (-offset, 0))
                self.screen.blit(image, (image.get_width()-offset, 0))
        else:
            # Fallback si se inicia sin descargar el paquete gráfico.
            for layer, (color, factor, base) in enumerate(((far, .12, 450), (near, .25, 505))):
                offset = int(self.camera * factor)
                for i in range(-1, 7):
                    x = i * 260 - offset % 260
                    pygame.draw.polygon(self.screen, color, [(x, base), (x+70, base-95-layer*28),
                        (x+150, base-30), (x+220, base-130-layer*22), (x+280, base)])
            for i in range(46):
                x = (i * 137 - int(self.camera*.16)) % W
                y = 45 + (i*71) % 290
                pygame.draw.circle(self.screen, accent, (x, y), 1 + i % 2)
        # Tinte tenue por zona para preservar la lectura de las plataformas.
        tint = ((30, 66, 42, 35), (26, 64, 97, 40), (71, 35, 104, 48))[zone]
        overlay = pygame.Surface((W, H), pygame.SRCALPHA)
        overlay.fill(tint)
        self.screen.blit(overlay, (0, 0))
        for rect in self.platforms:
            view = rect.move(-int(self.camera), 0)
            if view.right < -10 or view.left > W+10:
                continue
            region = min(2, rect.centerx // ZONE_W)
            if rect.height >= 100:
                ground_colors=((30,48,43),(27,39,58),(40,31,59))
                top_colors=((104,165,113),(105,198,211),(174,137,202))
                pygame.draw.rect(self.screen,ground_colors[region],view)
                pygame.draw.rect(self.screen,top_colors[region],(view.x,view.y+3,view.w,5),border_radius=3)
                if self.ground_art:
                    # Enmarca cada tramo con el arte pintado, conserva su zona interior
                    # oscura como roca y tiñe suavemente según el bioma.
                    art_h = min(view.h, max(58, min(78, view.w // 7)))
                    art = pygame.transform.smoothscale(self.ground_art, (view.w, art_h))
                    art.set_alpha(235)
                    self.screen.blit(art, (view.x, view.y-8))
                # Variación mineral sutil bajo el borde de musgo.
                rng=random.Random(rect.x+region*7919)
                for _ in range(max(7,view.w//24)):
                    gx=rng.randint(view.x+8,max(view.x+8,view.right-26))
                    gy=rng.randint(view.y+23,min(view.bottom-8,view.y+view.h-14))
                    width=rng.randint(8,24)
                    stone=tuple(min(255,c+rng.randint(8,20)) for c in ground_colors[region])
                    pygame.draw.ellipse(self.screen,stone,(gx,gy,width,6))
                    pygame.draw.line(self.screen,tuple(min(255,c+8) for c in stone),
                                     (gx+3,gy+2),(gx+width-4,gy+2),1)
                if region==1:
                    for gx in range(view.x+50,view.right-20,145):
                        pygame.draw.polygon(self.screen,(75,130,163),((gx-9,view.y),(gx,view.y-22),(gx+9,view.y)))
                elif region==2:
                    for gx in range(view.x+35,view.right-10,95):
                        pygame.draw.circle(self.screen,(218,183,239),(gx,view.y+23),2)
            elif region == 0 and self.platform_art:
                pygame.draw.rect(self.screen,(40,63,49),(view.x,view.y,view.w,view.h),border_radius=4)
                art_h = max(46, int(view.w*.41))
                art = pygame.transform.smoothscale(self.platform_art, (view.w, art_h))
                self.screen.blit(art, (view.x, view.y-int(art_h*.27)))
            elif region == 1:
                pygame.draw.rect(self.screen,(39,54,83),(view.x,view.y+5,view.w,view.h),border_radius=6)
                pygame.draw.polygon(self.screen,(91,154,174),((view.x,view.y+7),(view.x+14,view.y-6),(view.x+view.w-14,view.y-6),(view.right,view.y+7)))
                pygame.draw.line(self.screen,(160,238,246),(view.x+18,view.y+3),(view.right-18,view.y+3),3)
                for cx in (view.x+20,view.right-20):
                    pygame.draw.polygon(self.screen,(68,116,160),((cx-9,view.y+17),(cx,view.y+7),(cx+9,view.y+17),(cx,view.y+view.h-3)))
            elif region == 2:
                pygame.draw.rect(self.screen,(64,49,91),(view.x,view.y+4,view.w,view.h),border_radius=12)
                pygame.draw.rect(self.screen,(128,95,158),(view.x,view.y-5,view.w,13),border_radius=8)
                pygame.draw.line(self.screen,(220,185,250),(view.x+14,view.y-1),(view.right-14,view.y-1),2)
                for cx in range(view.x+24,view.right-12,44):
                    pygame.draw.circle(self.screen,(237,206,255),(cx,view.y+12),3)
            else:
                pygame.draw.rect(self.screen, (19, 31, 38), (view.x, view.y+8, view.w, view.h), border_radius=5)
                pygame.draw.rect(self.screen, (47, 64, 60), view, border_radius=7)
                pygame.draw.rect(self.screen, (86, 143, 98), (view.x, view.y, view.w, 9), border_radius=4)
                for gx in range(view.x+16, view.right-4, 42):
                    pygame.draw.line(self.screen, (75, 102, 83), (gx, view.y+17), (gx+13, view.y+29), 2)
        for index, world_x in enumerate((120,900,1990,2860,3830,4800)):
            self.draw_magic_house(world_x - int(self.camera*.55), 135 + (index%2)*32, index//2)

    def draw_magic_house(self, x: int, height: int, style: int) -> None:
        """Siluetas de santuarios fantásticos: sin letreros ni nombres flotantes."""
        if x < -180 or x > W+180:
            return
        base_y = 573
        palette = ((70,88,93),(65,75,113),(74,59,109))
        stone = palette[min(2,style)]
        glow = ((170,225,175),(120,224,245),(223,181,255))[min(2,style)]
        center = x+70
        if style == 0:  # casa de tronco encantado
            body_top=base_y-int(height*.57)
            pygame.draw.rect(self.screen,stone,(x+35,body_top,76,base_y-body_top),border_radius=15)
            pygame.draw.polygon(self.screen,(118,94,139),((x+18,body_top+9),(center,base_y-height),(x+128,body_top+9),(x+116,body_top+22),(x+30,body_top+22)))
            pygame.draw.line(self.screen,(192,157,204),(x+34,body_top+22),(x+106,body_top+22),3)
            pygame.draw.ellipse(self.screen,(36,44,62),(center-14,base_y-48,28,48))
            pygame.draw.ellipse(self.screen,glow,(x+43,body_top+28,12,19))
            pygame.draw.ellipse(self.screen,glow,(x+91,body_top+28,12,19))
        elif style == 1:  # vivienda de cristal
            pygame.draw.polygon(self.screen,stone,((center-56,base_y),(center-48,base_y-height*.55),(center,base_y-height),(center+48,base_y-height*.55),(center+56,base_y)))
            pygame.draw.polygon(self.screen,(91,113,158),((center-42,base_y-height*.55),(center,base_y-height),(center,base_y)))
            pygame.draw.line(self.screen,glow,(center,base_y-height+18),(center,base_y-15),4)
        else:  # pabellón del observatorio con anillo celeste
            pygame.draw.rect(self.screen,stone,(x+38,base_y-height*.6,66,height*.6),border_radius=13)
            pygame.draw.polygon(self.screen,(106,83,145),((x+22,base_y-height*.6),(center,base_y-height),(x+120,base_y-height*.6)))
            pygame.draw.ellipse(self.screen,glow,(x+12,base_y-height-23,116,38),4)
        for wx in (center-22,center+12):
            pygame.draw.ellipse(self.screen,glow,(wx,base_y-height*.39,12,22))

    def draw_terminal(self, node: dict) -> None:
        x = int(node["x"] - self.camera)
        if not -60 < x < W+60:
            return
        zone = min(2, node["x"] // ZONE_W)
        colors = ((152,235,177),(107,226,247),(216,171,255))
        glow = (78,92,102) if node["done"] else colors[zone]
        aura = pygame.Surface((124,142),pygame.SRCALPHA)
        pygame.draw.ellipse(aura,(*glow,42),(4,4,116,132))
        self.screen.blit(aura,(x-62,438))
        pygame.draw.polygon(self.screen,(56,66,82),((x-20,558),(x-13,545),(x+13,545),(x+20,558)))
        pygame.draw.ellipse(self.screen,(58,74,91),(x-27,551,54,14))
        float_y = int(math.sin(pygame.time.get_ticks()/330+x*.01)*5)
        crystal = [(x,474+float_y),(x+20,500+float_y),(x+14,535+float_y),(x,546+float_y),(x-14,535+float_y),(x-20,500+float_y)]
        pygame.draw.polygon(self.screen,glow,crystal)
        pygame.draw.polygon(self.screen,(229,251,255),((x,480+float_y),(x+4,502+float_y),(x+1,531+float_y),(x-8,524+float_y)),0)
        pygame.draw.polygon(self.screen,(32,45,65),crystal,2)
        for i in range(3):
            r = 35 + i*8
            pygame.draw.arc(self.screen,glow,(x-r,490-r//3+float_y,2*r,r),3.4,5.9,1)
        if node["done"]:
            pygame.draw.circle(self.screen,MINT,(x,513+float_y),5)

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
                frames = self.boss_walk_frames if abs(wisp["x"]-wisp["home"])>10 and self.boss_walk_frames else self.boss_frames
                frame = frames[int(pygame.time.get_ticks()/115) % len(frames)]
                height = 150
                scale = height / max(1, frame.get_height())
                sprite = pygame.transform.scale(frame,(max(1,int(frame.get_width()*scale)),height))
                glow = pygame.Surface((220,210),pygame.SRCALPHA)
                pygame.draw.ellipse(glow,(184,100,181,38),(15,12,190,185))
                self.screen.blit(glow,(int(x-110),int(574-190)))
                self.screen.blit(sprite,(int(x-sprite.get_width()/2),574-height))
                pygame.draw.ellipse(self.screen,(23,18,39),(int(x-52),560,104,18))
                pygame.draw.rect(self.screen,(44,30,37),(x-38,463,76,7),border_radius=3)
                pygame.draw.rect(self.screen,(198,89,128),(x-38,463,int(76*wisp["hp"]/8),7),border_radius=3)
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
            if not wisp.get("boss"):
                pygame.draw.circle(self.screen,(255,220,173),(int(x-6),int(y-5)),2)
                pygame.draw.circle(self.screen,(255,220,173),(int(x+6),int(y-5)),2)
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
        self.text("A/D o ←→ mover   ESPACIO saltar   X pulso   E cristal   M mapa   H ayuda",38,H-52,CREAM,self.small)
        nearest = next((n for n in self.terminals if abs(n["x"]-self.player.centerx)<90 and not n["done"]),None)
        if nearest and self.dialog is None:
            self.panel((W//2-142,H-119,284,42),(249,222,160),13)
            self.text("E  ·  Activar cristal",W//2-119,H-108,INK,self.small)
        if self.message and self.dialog is None:
            self.text(self.message[:92],25,101,(221,229,231),self.small)

    def draw_dialog(self) -> None:
        if not self.dialog:
            return
        shade=pygame.Surface((W,H),pygame.SRCALPHA); shade.fill((8,12,24,175)); self.screen.blit(shade,(0,0))
        if self.dialog.get("stage") == "challenge":
            self.draw_challenge()
            return
        self.panel((150,177,800,383),(246,240,221),25,(250,190,91))
        node=self.dialog
        self.text("FRAGMENTO RECUPERADO",190,205,(49,105,86),self.bold)
        self.text("MENSAJE",190,252,(93,105,111),self.small)
        self.text_wrapped(node["pub"].text,190,280,715,INK,self.bold)
        self.text_wrapped("Fuente: "+node["pub"].source,190,348,715,(83,100,108),self.small)
        lines=["V  Contrastar la fuente", "C  Compartir (después de verificar)",
               "R  Reportar si no es fiable", "I  No amplificar", "ESC  Cerrar"]
        for i,line in enumerate(lines):
            self.text(line,197,405+i*27,(50,86,87),self.small)
        if self.message:
            self.text_wrapped(self.message,525,418,375,(111,82,42),self.small)

    def begin_challenge(self, node: dict) -> None:
        node_index = self.terminals.index(node)
        self.challenge_node = node
        node["pub"].verified = None
        self.challenge_feedback = "Resuelve el juego para recuperar el mensaje."
        self.dialog = {"stage":"challenge", "node":node}
        if node["challenge"] == "math":
            a, b = 8 + node_index, 3 + node_index % 3
            if node_index % 2:
                a, b = a + 5, b
                answer = a - b
                expression = f"{a} − {b} = ?"
            else:
                answer = a + b
                expression = f"{a} + {b} = ?"
            self.challenge_answer = answer
            self.challenge_options = [str(answer), str(answer+2), str(answer-3)]
            random.shuffle(self.challenge_options)
            self.challenge_answer = self.challenge_options.index(str(answer))
            self.challenge_prompt = expression
        elif node["challenge"] == "source":
            options = [
                "Calendario oficial con fecha y enlace",
                "Captura reenviada sin contexto",
                "Audio anónimo que pide compartir ya",
            ]
            random.shuffle(options)
            self.challenge_options = options
            self.challenge_answer = options.index("Calendario oficial con fecha y enlace")
            self.challenge_prompt = "¿Qué evidencia merece más confianza?"
        else:
            self.tic_board = [""] * 9
            self.tic_turn = "X"
            self.challenge_prompt = "Haz tres en raya para romper el sello."

    def check_tic_winner(self) -> str | None:
        lines = ((0,1,2),(3,4,5),(6,7,8),(0,3,6),(1,4,7),(2,5,8),(0,4,8),(2,4,6))
        for a,b,c in lines:
            if self.tic_board[a] and self.tic_board[a] == self.tic_board[b] == self.tic_board[c]:
                return self.tic_board[a]
        return "draw" if all(self.tic_board) else None

    def complete_challenge(self) -> None:
        node = self.challenge_node
        if not node:
            return
        node["unlocked"] = True
        self.challenge_node = None
        self.dialog = node
        self.message = "El cristal cedió. Ahora revisa el mensaje y su fuente."

    def answer_challenge(self, choice: int) -> None:
        if not self.challenge_node or not 0 <= choice < len(self.challenge_options):
            return
        if choice == self.challenge_answer:
            self.complete_challenge()
        else:
            self.challenge_feedback = "No coincide. Prueba otra vez; el cristal sigue abierto."

    def play_tic(self, cell: int) -> None:
        if self.tic_turn != "X" or not 0 <= cell < 9 or self.tic_board[cell]:
            return
        self.tic_board[cell] = "X"
        winner = self.check_tic_winner()
        if winner == "X" or winner == "draw":
            self.complete_challenge(); return
        self.tic_turn = "O"
        choices = [i for i,v in enumerate(self.tic_board) if not v]
        if choices:
            self.tic_board[random.choice(choices)] = "O"
        winner = self.check_tic_winner()
        if winner == "O":
            self.challenge_feedback = "El sello se reinició. Puedes volver a intentarlo."
            self.tic_board = [""] * 9
            self.tic_turn = "X"
        else:
            self.tic_turn = "X"

    def draw_challenge(self) -> None:
        node = self.challenge_node
        if not node:
            return
        self.panel((125,112,850,505),(239,237,224),26,(167,202,220))
        self.text("DESAFÍO DEL CRISTAL",180,145,(55,89,104),self.bold)
        self.text_wrapped(self.challenge_prompt,180,196,735,INK,self.bold)
        if node["challenge"] == "tic":
            left, top, size = 400, 290, 100
            for i, mark in enumerate(self.tic_board):
                row, col = divmod(i,3)
                rect = pygame.Rect(left+col*size,top+row*size,size-5,size-5)
                pygame.draw.rect(self.screen,(208,223,222),rect,border_radius=12)
                pygame.draw.rect(self.screen,(115,159,168),rect,2,border_radius=12)
                if mark:
                    self.text(mark,rect.centerx-19,rect.centery-27,(70,117,135) if mark=="X" else (142,95,159),self.bold)
                else:
                    self.text(str(i+1),rect.centerx-6,rect.centery-12,(120,145,146),self.small)
            self.text("Pulsa 1–9 o elige una casilla con el ratón.",345,600,(79,100,106),self.small)
        else:
            for i, option in enumerate(self.challenge_options):
                rect=pygame.Rect(180+i*245,380,225,120)
                self.panel(rect,(215,227,220),(16),(125,171,173))
                self.text_wrapped(f"{i+1}. {option}",rect.x+15,rect.y+24,195,(43,71,75),self.small)
                self.text("ELEGIR",rect.x+76,rect.bottom-29,(66,115,105),self.small)
            self.text("Pulsa 1, 2 o 3; también puedes hacer clic.",365,535,(79,100,106),self.small)
        self.text_wrapped(self.challenge_feedback,180,563,735,(135,84,71),self.small)
        self.text("ESC  ·  Salir del reto",180,585,(102,110,108),self.small)

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
        for i, color in enumerate(((129,177,137),(99,195,214),(173,136,218))):
            left=230+i*210
            pygame.draw.rect(self.screen,color,(left,346,198,25),border_radius=9)
            self.text(ZONE_NAMES[i],left-5,315,(62,76,83),self.small)
        pygame.draw.line(self.screen,(120,144,139),(230,359),(858,359),3)
        for n in self.terminals:
            x=230+int(n["x"]/WORLD_W*628)
            pygame.draw.circle(self.screen,MINT if n["done"] else GOLD,(x,359),16)
            pygame.draw.circle(self.screen,(40,62,68),(x,359),5)
        px=230+int(self.player.centerx/WORLD_W*628)
        pygame.draw.polygon(self.screen,CORAL,((px,327),(px-10,344),(px+10,344)))
        self.text("Resuelve el reto de cada cristal para descubrir mensajes.",195,450,(65,81,86),self.small)
        self.text("M o ESC para volver",195,489,(65,81,86),self.small)

    def draw_help(self):
        shade=pygame.Surface((W,H),pygame.SRCALPHA); shade.fill((8,12,24,205)); self.screen.blit(shade,(0,0))
        self.panel((190,160,720,400),(246,240,221),24,(115,188,230))
        self.text("AVENTURA Y CIUDADANÍA DIGITAL",230,191,(49,105,86),self.bold)
        help_lines=["Explora tres zonas; cambia el estilo de las plataformas al avanzar.",
        "Resuelve el reto de cada cristal para encontrar una publicación.",
        "Verifica la fuente y el contexto antes de compartir.",
        "Los rumores son ecos: pulsa X para dispersarlos.",
        "Mover: A/D o flechas   ·   Saltar: Espacio", "Cristal: E   ·   Pulso: X   ·   Mapa: M",
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
            enemy=pygame.Rect(w["x"]-46,456,92,116) if w.get("boss") else pygame.Rect(w["x"]-18,515,36,50)
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
            target=pygame.Rect(w["x"]-48,474,96,100) if w.get("boss") else pygame.Rect(w["x"]-22,514,44,47)
            if w["hp"]>0 and hit.colliderect(target):
                w["hp"]-=1; w["flash"]=.18
                for _ in range(9): self.sparks.append([w["x"],535,random.uniform(-150,150),random.uniform(-220,-40),.35])
                if w["hp"]<=0:
                    self.state.change(misinformation=-3,trust=1,digital_wellbeing=1)
                    self.message="Eco dispersado: contrastar y no amplificar reduce su alcance."

    def interact(self):
        node=min(self.terminals,key=lambda n:abs(n["x"]-self.player.centerx))
        if abs(node["x"]-self.player.centerx)<100:
            if node["done"]: self.message="Ya investigaste esta publicación; explora hacia la siguiente luz."
            elif not node["unlocked"]:
                self.begin_challenge(node)
            else:
                self.dialog=node; node["pub"].verified=None
                self.message="Compara la fuente y el contexto antes de decidir."
        else: self.message="Acércate a un cristal para activar su reto."

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
        elif self.dialog and self.dialog.get("stage") == "challenge":
            if event.type == pygame.MOUSEBUTTONDOWN and event.button == 1:
                x,y=event.pos
                if self.challenge_node and self.challenge_node["challenge"] == "tic":
                    if 400 <= x < 700 and 290 <= y < 590:
                        col=(x-400)//100; row=(y-290)//100
                        self.play_tic(int(row*3+col))
                elif 380 <= y <= 510:
                    for i in range(3):
                        if 180+i*245 <= x <= 405+i*245:
                            self.answer_challenge(i); break
            elif event.type == pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    self.dialog=None; self.challenge_node=None
                elif pygame.K_1 <= event.key <= pygame.K_9 and self.challenge_node and self.challenge_node["challenge"] == "tic":
                    self.play_tic(event.key-pygame.K_1)
                elif event.key in (pygame.K_1,pygame.K_2,pygame.K_3):
                    self.answer_challenge(event.key-pygame.K_1)
            return
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
