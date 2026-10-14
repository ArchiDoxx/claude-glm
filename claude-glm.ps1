# claude-glm.ps1 — Claude Code mit GLM-Modellen ueber Z.ai (PowerShell)
# Einbinden im Profil:  . "$env:USERPROFILE\claude-glm\claude-glm.ps1"
#
# Startet Claude Code gegen den Anthropic-kompatiblen Endpunkt von Z.ai (GLM Coding Plan).
# Hauptagent GLM-5.3; Opus- und Sonnet-Slot GLM-5.3, Haiku-Slot und Subagenten-Default
# GLM-5.3-Flash. Der Schluessel kommt aus der Benutzervariable ZAI_API_KEY (einmalig per
# setx gesetzt), nie aus einer Datei. Alle Variablen gelten nur fuer diesen Aufruf.
# claude und claude-u bleiben unveraendert; claude-glm = Hauptprofil, claude-u-glm = Uni-Profil.
# --mt als erstes Argument startet im Onsite.ai-OS-Maintainer-Modus.

$script:ClaudeGlmMain    = "glm-5.3[1m]"
$script:ClaudeGlmFlash   = "glm-5.3-flash[1m]"
$script:ClaudeGlmBaseUrl = "https://api.z.ai/api/anthropic"

function Invoke-ClaudeGlm {
  param([string[]]$ClaudeArgs)
  # --mt (nur als erstes Argument): Maintainer-Modus des Onsite.ai-OS wie claude-m
  if ($ClaudeArgs -and $ClaudeArgs[0] -eq '--mt') {
    $ClaudeArgs = @('--settings', "$env:USERPROFILE\.claude\oai\maintainer.json") + @($ClaudeArgs | Select-Object -Skip 1)
  }
  if (-not $env:ZAI_API_KEY) {
    Write-Error "ZAI_API_KEY fehlt. Einmalig setzen: setx ZAI_API_KEY <schluessel>, danach neue Shell."
    return
  }
  $env:ANTHROPIC_BASE_URL              = $script:ClaudeGlmBaseUrl
  $env:ANTHROPIC_AUTH_TOKEN            = $env:ZAI_API_KEY
  $env:ANTHROPIC_DEFAULT_OPUS_MODEL    = $script:ClaudeGlmMain
  $env:ANTHROPIC_DEFAULT_SONNET_MODEL  = $script:ClaudeGlmMain
  $env:ANTHROPIC_DEFAULT_HAIKU_MODEL   = $script:ClaudeGlmFlash
  $env:CLAUDE_CODE_SUBAGENT_MODEL      = $script:ClaudeGlmFlash
  $env:API_TIMEOUT_MS                  = "3000000"
  $env:CLAUDE_CODE_AUTO_COMPACT_WINDOW = "1000000"
  try { claude --model $script:ClaudeGlmMain @ClaudeArgs }
  finally {
    foreach ($n in 'ANTHROPIC_BASE_URL','ANTHROPIC_AUTH_TOKEN','ANTHROPIC_DEFAULT_OPUS_MODEL',
                   'ANTHROPIC_DEFAULT_SONNET_MODEL','ANTHROPIC_DEFAULT_HAIKU_MODEL',
                   'CLAUDE_CODE_SUBAGENT_MODEL','API_TIMEOUT_MS','CLAUDE_CODE_AUTO_COMPACT_WINDOW') {
      Remove-Item "Env:$n" -ErrorAction SilentlyContinue
    }
  }
}

# Hauptprofil (~/.claude)
function claude-glm { Invoke-ClaudeGlm -ClaudeArgs $args }

# Uni-Profil (~/.claude-uni), Plugin-Bestand des Hauptprofils wird mitgenutzt
function claude-u-glm {
  $env:CLAUDE_CONFIG_DIR = "$env:USERPROFILE\.claude-uni"
  $env:CLAUDE_CODE_PLUGIN_CACHE_DIR = "$env:USERPROFILE\.claude\plugins"
  try { Invoke-ClaudeGlm -ClaudeArgs $args }
  finally {
    Remove-Item Env:CLAUDE_CONFIG_DIR -ErrorAction SilentlyContinue
    Remove-Item Env:CLAUDE_CODE_PLUGIN_CACHE_DIR -ErrorAction SilentlyContinue
  }
}
