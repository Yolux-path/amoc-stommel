"""Vérifie l'ordre des schémas (modèle linéaire) et les seuils de l'hystérésis, puis trace les figures."""
import pathlib
import subprocess
import tempfile

import matplotlib.pyplot as plt
import numpy as np

ICI = pathlib.Path(__file__).resolve().parent
(ICI / "figures").mkdir(exist_ok=True)


def lancer(dossier, exe, sortie, parametres=None):
    subprocess.run(["make", "-s", "-C", str(ICI / dossier)], check=True, stderr=subprocess.DEVNULL)
    with tempfile.TemporaryDirectory() as tmp:
        if parametres:
            (pathlib.Path(tmp) / "parametres.dat").write_text(parametres + "\n")
        subprocess.run([str(ICI / dossier / exe)], cwd=tmp, check=True, stdout=subprocess.DEVNULL)
        return np.loadtxt(pathlib.Path(tmp) / sortie)


# Modèle linéaire (q constant) : erreur à t = 20 par rapport à la solution exacte
for schema, nom, attendu in [(1, "Euler explicite", 1), (2, "Euler implicite", 1), (3, "Heun", 2),
                             (4, "Crank-Nicolson", 2), (5, "RK4", 4)]:
    d = lancer("modele_lineaire", "exe", "err.dat", f"20.0 35.0 15.0 34.0 50.0 200.0 0.1 4.0 5 4 {schema}")
    ordre = np.log(d[-2, 1:] / d[-1, 1:]) / np.log(d[-2, 0] / d[-1, 0])
    print(f"{nom:16s} ordre T {ordre[0]:.2f}, S {ordre[1]:.2f} (attendu {attendu})")
    assert np.all(abs(ordre - attendu) < 0.1)
    plt.loglog(d[:, 0], d[:, 1], "o-", label=f"{nom} (ordre {ordre[0]:.2f})")
plt.xlabel("dt")
plt.ylabel("erreur sur T")
plt.legend()
plt.grid(which="both", alpha=0.3)
plt.savefig(ICI / "figures" / "convergence.png", dpi=150, bbox_inches="tight")
plt.close()

# Équilibres de Stommel (T* = 1, alpha = beta = 1), paramétrés par d = T - S, q = d²
TAU_T, TAU_S = 0.01, 3.0
d = np.linspace(-0.6, 1.0, 200001)
S = 1 / (1 + 2 * TAU_T * d**2) - d
S_star = S * (1 + 2 * TAU_S * d**2)
i = np.flatnonzero(np.diff(np.sign(np.diff(S_star)))) + 1
replis = sorted(S_star[i])
print("seuils théoriques S* :", np.round(replis, 3))

v = lancer("hysteresis", "exec", "valeurs.dat")
t, q, s_star = v[:, 0], v[:, 1], v[:, 5]
m = len(t) // 2
milieu = 0.15  # q entre les deux branches
aller = s_star[:m][np.flatnonzero(q[:m] > milieu)[-1]]
retour = s_star[m:][np.flatnonzero(q[m:] > milieu)[0]]
print(f"q franchit {milieu} à S* = {aller:.3f} (aller) et {retour:.3f} (retour)")
assert aller > replis[1] and retour < replis[0]  # le système dépasse le repli avant de basculer

plt.plot(S_star, d**2, "k--", lw=1, label="équilibres")
plt.plot(s_star[:m], q[:m], label="aller")
plt.plot(s_star[m:], q[m:], label="retour")
plt.xlim(0.5, 1.5)
plt.ylim(0, 1)
plt.xlabel("S*")
plt.ylabel("q")
plt.legend()
plt.grid(alpha=0.3)
plt.savefig(ICI / "figures" / "hysteresis.png", dpi=150, bbox_inches="tight")
