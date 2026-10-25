# Exploratoria sprint N · AAAA-MM-DD

Copiar este archivo como `EXP-sprint-N-AAAA-MM-DD.md` y llenarlo. Guía: [`../pruebas-exploratorias.md`](../pruebas-exploratorias.md).

## Sesión

| Campo | Valor |
|---|---|
| Fecha y duración | AAAA-MM-DD, 60 min |
| Personas | Guía: … · Prueban: … |
| Foco (charter) | Explorar … para encontrar … |
| HU / FC cubiertos | HU-M0X, FC-NN |
| Build probado | Solventa Dev `1.3.0-dev.214` (o run del CI / commit `abc1234`) |
| Cómo se instaló | App Distribution / `flutter install` desde `develop` |

## Dispositivos

| Dispositivo | Android | Tamaño / densidad | Notas |
|---|---|---|---|
| Ej.: Samsung Galaxy A14 | 14 | 6,6" · 400 dpi | Teléfono de … |
| Emulador Pixel Tablet | 14 (API 34) | 10,95" | |
| `device_preview` | — | 320, 390, 412, 600, 840 dp | Solo si ya existe en dev |

## Checklist

| # | Punto | Revisado | Hallazgos |
|---|---|---|---|
| 1 | Tamaños de pantalla | ☐ | |
| 2 | Orientación | ☐ | |
| 3 | Texto grande | ☐ | |
| 4 | Tamaño de visualización | ☐ | |
| 5 | Idioma y formato regional | ☐ | |
| 6 | Modo oscuro | ☐ | |
| 7 | Accesibilidad (Scanner y TalkBack) | ☐ | |
| 8 | Red (modo avión, red lenta) | ☐ | |
| 9 | Interrupciones | ☐ | |
| 10 | Gestos y botón atrás | ☐ | |

## Hallazgos

| ID | Pantalla | Dispositivo | Pasos | Esperado | Obtenido | Gravedad | Captura | Ticket |
|---|---|---|---|---|---|---|---|---|
| EXP-N-01 | M01-02 | Galaxy A14, texto al máximo | 1. … 2. … | El botón se ve completo | El botón queda cortado | Media | [captura](capturas/EXP-sprint-N/01.png) | KAN-… |

## Test Lab del release (si aplica)

| Prueba | Dispositivos | Resultado | Enlace |
|---|---|---|---|
| Robo test | … | Sin cierres / N cierres | Consola de Firebase |
| `integration_test` | … | N/N pasan | Consola de Firebase |

## Conclusión

Qué se aprendió, qué se corrige antes del release y qué prueba automática se agrega para que no vuelva.
