"""Replica el Thread Group de JMeter: N hilos, ramp-up R s, L bucles.
Cada hilo: GET /pets y GET /pets/{1..13}. Salida CSV formato JMeter (.jtl)."""
import sys, time, random, threading, urllib.request, csv
host, n, ramp, loops, out = sys.argv[1], int(sys.argv[2]), float(sys.argv[3]), int(sys.argv[4]), sys.argv[5]
rows, lock = [], threading.Lock()
def req(label, path):
    t0 = time.time(); code, ok, msg = "", False, ""
    try:
        with urllib.request.urlopen(host + path, timeout=60) as r:
            r.read(); code = str(r.status); msg = r.reason
    except urllib.error.HTTPError as e: code, msg = str(e.code), e.reason
    except Exception as e: code, msg = "Non HTTP", type(e).__name__
    el = int((time.time() - t0) * 1000); ok = "200" in code
    with lock: rows.append([int(t0*1000), el, label, code, msg, str(ok).lower(), threading.active_count()-1])
def user():
    for _ in range(loops):
        req("Petición HTTP - Listar mascotas", "/pets")
        req("Petición HTTP - Buscar mascota por id", f"/pets/{random.randint(1,13)}")
ths = []
start = time.time()
for i in range(n):
    t = threading.Thread(target=user, daemon=True); t.start(); ths.append(t)
    d = start + ramp * (i + 1) / n - time.time()
    if d > 0: time.sleep(d)
for t in ths: t.join()
with open(out, "w", newline="") as f:
    w = csv.writer(f); w.writerow(["timeStamp","elapsed","label","responseCode","responseMessage","success","allThreads"])
    w.writerows(sorted(rows))
print(f"{n} hilos: {len(rows)} muestras en {time.time()-start:.1f}s")
