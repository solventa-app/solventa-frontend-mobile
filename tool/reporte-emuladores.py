#!/usr/bin/env python3
"""Reporte HTML de las pruebas de integración en emuladores (emuladores.yml).

Uso: tool/reporte-emuladores.py <carpeta> <salida.html> [resumen.md]

<carpeta> tiene una subcarpeta por emulador con:
  - dispositivo.txt: nombre del emulador (p. ej. "Teléfono pequeño (API 28)")
  - resultados.json: salida de `flutter test --file-reporter json:...`
  - (opcional) contexto.txt: commit, rama y enlace a la corrida

Las capturas llegan dentro del JSON como líneas `@@captura|id|i|n|nombre|base64`
(integration_test/soporte/capturas.dart). Sale un solo HTML autocontenido y,
si se pide, un resumen en Markdown para el resumen del job.
"""
import html
import re
import json
import sys
from pathlib import Path

PREFIJO = "@@captura|"


def leer_eventos(ruta):
    eventos = []
    if not ruta.exists():
        return eventos
    for linea in ruta.read_text(encoding="utf-8", errors="replace").splitlines():
        linea = linea.strip()
        if not linea:
            continue
        try:
            eventos.append(json.loads(linea))
        except json.JSONDecodeError:
            continue
    return eventos


def procesar(eventos):
    """Devuelve la lista de pruebas con su resultado, errores, salida y capturas."""
    suites = {}
    pruebas = {}
    orden = []
    trozos = {}
    for ev in eventos:
        tipo = ev.get("type")
        if tipo == "suite":
            s = ev["suite"]
            suites[s["id"]] = s.get("path") or ""
        elif tipo == "testStart":
            t = ev["test"]
            pruebas[t["id"]] = {
                "nombre": t.get("name", ""),
                "archivo": suites.get(t.get("suiteID"), ""),
                "inicio": ev.get("time", 0),
                "fin": None,
                "resultado": "sin terminar",
                "oculta": False,
                "errores": [],
                "salida": [],
                "excepciones": [],
                "capturas": [],
            }
            orden.append(t["id"])
        elif tipo == "error" and ev.get("testID") in pruebas:
            pruebas[ev["testID"]]["errores"].append(
                (ev.get("error", ""), ev.get("stackTrace", ""))
            )
        elif tipo == "print" and ev.get("testID") in pruebas:
            msg = ev.get("message", "")
            if msg.startswith(PREFIJO):
                partes = msg.split("|", 5)
                if len(partes) == 6:
                    _, cid, i, n, nombre, datos = partes
                    clave = (ev["testID"], cid)
                    d = trozos.setdefault(clave, {"nombre": nombre, "n": int(n), "partes": {}})
                    d["partes"][int(i)] = datos
            elif "EXCEPTION CAUGHT BY" in msg:
                # El detalle del fallo (expect, overflow, tap fuera del botón) llega
                # como salida; el evento de error solo dice "See exception logs above".
                # Se agrupan las repetidas (mismo error en varios widgets).
                firma = re.sub(r"#[0-9a-f]{5}", "", "\n".join(msg.strip().splitlines()[:6]))
                excs = pruebas[ev["testID"]]["excepciones"]
                previa = next((e for e in excs if e["firma"] == firma), None)
                if previa:
                    previa["veces"] += 1
                else:
                    excs.append({"firma": firma, "texto": msg.strip(), "veces": 1})
            else:
                pruebas[ev["testID"]]["salida"].append(msg)
        elif tipo == "testDone" and ev.get("testID") in pruebas:
            p = pruebas[ev["testID"]]
            p["fin"] = ev.get("time", 0)
            p["oculta"] = bool(ev.get("hidden"))
            if ev.get("skipped"):
                p["resultado"] = "omitida"
            else:
                p["resultado"] = "pasó" if ev.get("result") == "success" else "falló"
    for (tid, cid), d in sorted(trozos.items(), key=lambda kv: int(kv[0][1])):
        if len(d["partes"]) == d["n"]:
            datos = "".join(d["partes"][i] for i in range(1, d["n"] + 1))
            pruebas[tid]["capturas"].append((d["nombre"], datos))
    lista = []
    for tid in orden:
        p = pruebas[tid]
        # Las pruebas ocultas son la carga de cada archivo (compilar e instalar):
        # solo interesan si fallaron.
        if p["oculta"] and p["resultado"] != "falló":
            continue
        if p["oculta"]:
            p["nombre"] = "No se pudo cargar el archivo de pruebas"
        p["archivo"] = p["archivo"].split("integration_test/")[-1] if p["archivo"] else ""
        p["segundos"] = ((p["fin"] or p["inicio"]) - p["inicio"]) / 1000
        lista.append(p)
    return lista


def esc(texto):
    return html.escape(str(texto), quote=True)


CSS = """
:root{--bg:#f6f7f9;--card:#fff;--fg:#14181f;--mut:#5b6472;--line:#dde1e8;--ac:#1a56db;
--ok:#0f7a3d;--okbg:#e5f5ec;--ko:#b42318;--kobg:#fdecea;--sk:#8a6100;--skbg:#fdf3dc;color-scheme:light}
@media (prefers-color-scheme:dark){:root:not([data-theme="light"]){--bg:#12151b;--card:#1a1e26;--fg:#eceff4;
--mut:#99a2b0;--line:#2a303a;--ac:#7aa2ff;--ok:#5fd68f;--okbg:#14301f;--ko:#ff8a80;--kobg:#3a1a18;
--sk:#f0c36b;--skbg:#33280f;color-scheme:dark}}
*{box-sizing:border-box}
body{margin:0;background:var(--bg);color:var(--fg);font:15px/1.5 system-ui,-apple-system,BlinkMacSystemFont,sans-serif;
padding:24px 16px 48px;max-width:1200px;margin-inline:auto}
h1{font-size:24px;margin:0 0 4px}h2{font-size:18px;margin:32px 0 12px}
p.mut,.mut{color:var(--mut)}
.chips{display:flex;flex-wrap:wrap;gap:8px;margin:16px 0}
.chip{border:1px solid var(--line);background:var(--card);border-radius:8px;padding:8px 12px;min-width:150px}
.chip b{display:block;font-size:20px}
table{width:100%;border-collapse:collapse;background:var(--card);border:1px solid var(--line);border-radius:8px;overflow:hidden}
th,td{padding:8px 10px;border-bottom:1px solid var(--line);text-align:left;vertical-align:top;font-size:14px}
th{font-size:12px;color:var(--mut);text-transform:uppercase;letter-spacing:.04em}
.tabla{overflow-x:auto}
.est{display:inline-block;font-weight:600;font-size:12px;padding:2px 8px;border-radius:999px;white-space:nowrap}
.pasó{color:var(--ok);background:var(--okbg)}.falló,.sin{color:var(--ko);background:var(--kobg)}
.omitida{color:var(--sk);background:var(--skbg)}
details{background:var(--card);border:1px solid var(--line);border-radius:8px;margin:8px 0}
summary{cursor:pointer;padding:10px 12px;display:flex;gap:10px;align-items:baseline;flex-wrap:wrap}
summary .arch{font:12px ui-monospace,monospace;color:var(--mut)}
.cuerpo{padding:0 12px 12px}
pre{background:var(--bg);border:1px solid var(--line);border-radius:6px;padding:10px;overflow-x:auto;
font:12px/1.45 ui-monospace,monospace;white-space:pre-wrap;word-break:break-word;max-height:280px;overflow-y:auto}
.fila{display:flex;gap:16px;overflow-x:auto;padding:4px 0 8px}
figure{margin:0;flex:none}
figure img{display:block;max-height:560px;max-width:min(80vw,700px);border:1px solid var(--line);border-radius:10px}
figcaption{font-size:12px;color:var(--mut);margin-top:6px;text-align:center}
a{color:var(--ac)}
"""


def clase(resultado):
    return "sin" if resultado == "sin terminar" else resultado


def generar(carpeta, salida, resumen_md=None):
    dispositivos = []
    for sub in sorted(p for p in Path(carpeta).iterdir() if p.is_dir()):
        nombre_f = sub / "dispositivo.txt"
        nombre = nombre_f.read_text(encoding="utf-8").strip() if nombre_f.exists() else sub.name
        ctx_f = sub / "contexto.txt"
        contexto = ctx_f.read_text(encoding="utf-8").strip() if ctx_f.exists() else ""
        resultados = sub / "resultados.json"
        pruebas = procesar(leer_eventos(resultados))
        dispositivos.append({"nombre": nombre, "pruebas": pruebas, "sin_json": not resultados.exists(),
                             "contexto": contexto})

    contexto = next((d["contexto"] for d in dispositivos if d["contexto"]), "")
    total_fallas = sum(1 for d in dispositivos for p in d["pruebas"] if p["resultado"] != "pasó" and p["resultado"] != "omitida")
    total_fallas += sum(1 for d in dispositivos if d["sin_json"] or not d["pruebas"])
    estado = "Todo en verde" if total_fallas == 0 else f"{total_fallas} con problemas"

    h = ['<!doctype html><html lang="es"><head><meta charset="utf-8">',
         '<meta name="viewport" content="width=device-width,initial-scale=1">',
         "<title>Reporte de emuladores</title>", f"<style>{CSS}</style></head><body>",
         "<h1>Reporte de emuladores</h1>",
         f'<p class="mut">Pruebas de integración (integration_test/) en emuladores Android. {esc(estado)}.</p>']
    if contexto:
        h.append(f'<p class="mut">{contexto}</p>')

    h.append('<div class="chips">')
    for d in dispositivos:
        ok = sum(1 for p in d["pruebas"] if p["resultado"] == "pasó")
        ko = sum(1 for p in d["pruebas"] if p["resultado"] in ("falló", "sin terminar"))
        txt = "sin resultados" if d["sin_json"] or not d["pruebas"] else f"{ok} pasaron · {ko} fallaron"
        h.append(f'<div class="chip"><span class="mut">{esc(d["nombre"])}</span><b>{esc(txt)}</b></div>')
    h.append("</div>")

    # Matriz prueba × emulador.
    claves = []
    for d in dispositivos:
        for p in d["pruebas"]:
            k = (p["archivo"], p["nombre"])
            if k not in claves:
                claves.append(k)
    if claves:
        h.append('<h2>Resumen</h2><div class="tabla"><table><thead><tr><th>Prueba</th>')
        h += [f"<th>{esc(d['nombre'])}</th>" for d in dispositivos]
        h.append("</tr></thead><tbody>")
        for arch, nom in claves:
            h.append(f'<tr><td>{esc(nom)}<br><span class="mut" style="font-size:12px">{esc(arch)}</span></td>')
            for d in dispositivos:
                p = next((x for x in d["pruebas"] if (x["archivo"], x["nombre"]) == (arch, nom)), None)
                if p is None:
                    h.append('<td class="mut">—</td>')
                else:
                    h.append(f'<td><span class="est {clase(p["resultado"])}">{esc(p["resultado"])}</span></td>')
            h.append("</tr>")
        h.append("</tbody></table></div>")

    for d in dispositivos:
        h.append(f'<h2>{esc(d["nombre"])}</h2>')
        if d["sin_json"] or not d["pruebas"]:
            h.append('<p class="mut">Este emulador no dejó resultados: falló antes de correr las pruebas '
                     '(arranque del emulador, compilación o instalación). Revisa el log del job.</p>')
            continue
        # Primero las que fallaron, abiertas.
        for p in sorted(d["pruebas"], key=lambda x: x["resultado"] == "pasó"):
            abierto = " open" if p["resultado"] in ("falló", "sin terminar") else ""
            h.append(f"<details{abierto}><summary>"
                     f'<span class="est {clase(p["resultado"])}">{esc(p["resultado"])}</span>'
                     f"<b>{esc(p['nombre'])}</b>"
                     f'<span class="arch">{esc(p["archivo"])} · {p["segundos"]:.1f} s</span></summary>'
                     '<div class="cuerpo">')
            for err, pila in p["errores"]:
                if p["excepciones"] and "See exception logs above" in err:
                    continue
                h.append(f"<pre>{esc(err)}\n\n{esc(pila)}</pre>")
            if p["capturas"]:
                h.append('<div class="fila">')
                for nom, datos in p["capturas"]:
                    h.append(f'<figure><img loading="lazy" alt="{esc(nom)}" src="data:image/png;base64,{datos}">'
                             f"<figcaption>{esc(nom)}</figcaption></figure>")
                h.append("</div>")
            for exc in p["excepciones"]:
                veces = f" (se repitió {exc['veces']} veces)" if exc["veces"] > 1 else ""
                h.append(f"<pre>{esc(exc['texto'])}{esc(veces)}</pre>")
            if p["salida"]:
                h.append("<details><summary>Salida de la prueba</summary><div class=\"cuerpo\">"
                         f"<pre>{esc(chr(10).join(p['salida']))}</pre></div></details>")
            if not (p["errores"] or p["excepciones"] or p["capturas"] or p["salida"]):
                h.append('<p class="mut">Sin errores ni capturas.</p>')
            h.append("</div></details>")
    h.append("</body></html>")
    Path(salida).write_text("\n".join(h), encoding="utf-8")

    if resumen_md:
        md = [f"### Emuladores: {estado}", "", "| Emulador | Pasaron | Fallaron |", "|---|---|---|"]
        for d in dispositivos:
            ok = sum(1 for p in d["pruebas"] if p["resultado"] == "pasó")
            ko = sum(1 for p in d["pruebas"] if p["resultado"] in ("falló", "sin terminar"))
            if d["sin_json"] or not d["pruebas"]:
                md.append(f"| {d['nombre']} | — | sin resultados |")
            else:
                md.append(f"| {d['nombre']} | {ok} | {ko} |")
        fallas = [(d["nombre"], p) for d in dispositivos for p in d["pruebas"] if p["resultado"] in ("falló", "sin terminar")]
        if fallas:
            md += ["", "**Fallaron:**"]
            md += [f"- {n}: {p['nombre']} (`{p['archivo']}`)" for n, p in fallas]
        md += ["", "El detalle con errores y capturas está en el artifact `reporte-emuladores` de esta corrida."]
        with open(resumen_md, "a", encoding="utf-8") as f:
            f.write("\n".join(md) + "\n")


if __name__ == "__main__":
    if len(sys.argv) < 3:
        sys.exit(__doc__)
    generar(sys.argv[1], sys.argv[2], sys.argv[3] if len(sys.argv) > 3 else None)
