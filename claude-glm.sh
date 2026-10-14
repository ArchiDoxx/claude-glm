# claude-glm.sh — Claude Code mit GLM-Modellen ueber Z.ai (Git Bash / bash)
# Einbinden in ~/.bashrc:  [ -f "$HOME/claude-glm/claude-glm.sh" ] && . "$HOME/claude-glm/claude-glm.sh"
#
# Startet Claude Code gegen den Anthropic-kompatiblen Endpunkt von Z.ai (GLM Coding Plan).
# Hauptagent GLM-5.3; Opus- und Sonnet-Slot GLM-5.3, Haiku-Slot und Subagenten-Default
# GLM-5.3-Flash. Der Schluessel kommt aus der Benutzervariable ZAI_API_KEY (einmalig per
# setx gesetzt), nie aus einer Datei. Alle Variablen gelten nur fuer diesen Aufruf.
# claude und claude-u bleiben unveraendert; claude-glm = Hauptprofil, claude-u-glm = Uni-Profil.
# --mt als erstes Argument startet im Onsite.ai-OS-Maintainer-Modus.

CLAUDE_GLM_MAIN="glm-5.3[1m]"
CLAUDE_GLM_FLASH="glm-5.3-flash[1m]"
CLAUDE_GLM_BASE_URL="https://api.z.ai/api/anthropic"

_claude_glm_run() {
  # --mt (nur als erstes Argument): Maintainer-Modus des Onsite.ai-OS wie claude-m
  if [ "${1:-}" = "--mt" ]; then
    shift
    set -- --settings "$HOME/.claude/oai/maintainer.json" "$@"
  fi
  if [ -z "$ZAI_API_KEY" ]; then
    echo "claude-glm: ZAI_API_KEY fehlt. Einmalig setzen: setx ZAI_API_KEY <schluessel>, danach neue Shell." >&2
    return 1
  fi
  ANTHROPIC_BASE_URL="$CLAUDE_GLM_BASE_URL" \
  ANTHROPIC_AUTH_TOKEN="$ZAI_API_KEY" \
  ANTHROPIC_DEFAULT_OPUS_MODEL="$CLAUDE_GLM_MAIN" \
  ANTHROPIC_DEFAULT_SONNET_MODEL="$CLAUDE_GLM_MAIN" \
  ANTHROPIC_DEFAULT_HAIKU_MODEL="$CLAUDE_GLM_FLASH" \
  CLAUDE_CODE_SUBAGENT_MODEL="$CLAUDE_GLM_FLASH" \
  API_TIMEOUT_MS="3000000" \
  CLAUDE_CODE_AUTO_COMPACT_WINDOW="1000000" \
  claude --model "$CLAUDE_GLM_MAIN" "$@"
}

# Hauptprofil (~/.claude)
claude-glm() { _claude_glm_run "$@"; }

# Uni-Profil (~/.claude-uni), Plugin-Bestand des Hauptprofils wird mitgenutzt
claude-u-glm() {
  CLAUDE_CONFIG_DIR="$HOME/.claude-uni" \
  CLAUDE_CODE_PLUGIN_CACHE_DIR="$HOME/.claude/plugins" \
  _claude_glm_run "$@"
}
