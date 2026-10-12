# claude-glm

Shell-Wrapper, die Claude Code mit GLM-Modellen über den Anthropic-kompatiblen Endpunkt
von Z.ai (GLM Coding Plan) starten. `claude` und `claude-u` bleiben unverändert; GLM ist
eine zweite Option daneben.

| Befehl         | Profil                     | Hauptagent    | Subagenten-Default   |
|----------------|----------------------------|---------------|----------------------|
| `claude-glm`   | Hauptprofil `~/.claude`    | `glm-5.3[1m]` | `glm-5.3-flash[1m]`  |
| `claude-u-glm` | Uni-Profil `~/.claude-uni` | `glm-5.3[1m]` | `glm-5.3-flash[1m]`  |

Modell-Slots: Opus und Sonnet auf `glm-5.3[1m]`, Haiku auf `glm-5.3-flash[1m]`. Ein Subagent
ohne Modellangabe oder mit `haiku` läuft also auf Flash, mit `sonnet` oder `opus` auf dem
großen GLM. Alle Argumente werden durchgereicht (`claude-glm --resume`, `claude-u-glm -p "..."`).

## Installation

```powershell
git clone https://github.com/ArchiDoxx/claude-glm "$env:USERPROFILE\claude-glm"
```

PowerShell-Profil (`$PROFILE`):

```powershell
. "$env:USERPROFILE\claude-glm\claude-glm.ps1"
```

Git Bash (`~/.bashrc`):

```bash
[ -f "$HOME/claude-glm/claude-glm.sh" ] && . "$HOME/claude-glm/claude-glm.sh"
```

## Schlüssel

Der Z.ai-API-Schlüssel liegt ausschließlich in der Windows-Benutzervariable `ZAI_API_KEY`,
nie in einer Datei dieses Repos:

```powershell
setx ZAI_API_KEY <schluessel>
```

Danach eine neue Shell öffnen. Fehlt die Variable, brechen die Wrapper mit Meldung ab.
Bei Schlüssel-Rotation `setx` wiederholen.

## Update

```powershell
git -C "$env:USERPROFILE\claude-glm" pull
```

Neue Shell öffnen, fertig. Modell-IDs stehen oben in `claude-glm.ps1` und `claude-glm.sh`
(`ClaudeGlmMain` / `CLAUDE_GLM_MAIN`, `ClaudeGlmFlash` / `CLAUDE_GLM_FLASH`).

## Gesetzte Variablen (nur für den Prozess)

- `ANTHROPIC_BASE_URL=https://api.z.ai/api/anthropic`
- `ANTHROPIC_AUTH_TOKEN=$ZAI_API_KEY`
- `ANTHROPIC_DEFAULT_OPUS_MODEL`, `ANTHROPIC_DEFAULT_SONNET_MODEL`, `ANTHROPIC_DEFAULT_HAIKU_MODEL`
- `CLAUDE_CODE_SUBAGENT_MODEL`
- `API_TIMEOUT_MS=3000000`, `CLAUDE_CODE_AUTO_COMPACT_WINDOW=1000000`

Quelle für Endpunkt und Mapping: [Z.ai Claude Code Doku](https://docs.z.ai/devpack/tool/claude).

## Bekannte Hinweise

- Claude Code meldet `unrecognized_model` für `glm-5.3[1m]`, reicht das Modell aber
  unverändert durch; Z.ai akzeptiert es (geprüft 2026-10-12 mit Claude Code 2.1.296).
- In der GLM-Session sind claude.ai-Connectors deaktiviert, weil der Auth-Token Vorrang hat.
- Die Kostenangabe in der JSON-Ausgabe von Claude Code ist eine Schätzung ohne Preisbasis,
  nicht die Abrechnung des Coding Plans.
