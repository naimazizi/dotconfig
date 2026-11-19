import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  const baseUrl = process.env.LITELLM_API_ENDPOINT?.trim();
  const apiKey = process.env.LITELLM_API_KEY?.trim();

  async function checkLiteLLM(signal?: AbortSignal) {
    if (!baseUrl || !apiKey) throw new Error("LiteLLM endpoint or API key is missing");
    const response = await fetch(`${baseUrl.replace(/\/+$/, "")}/models`, {
      headers: { Authorization: `Bearer ${apiKey}` },
      signal: signal ? AbortSignal.any([signal, AbortSignal.timeout(2000)]) : AbortSignal.timeout(2000),
    });
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
  }

  pi.registerVirtualModel<{ provider: string }>({
    provider: "local-router",
    id: "subagent-luna",
    name: "Subagent Luna (LiteLLM or Codex)",
    contextWindow: 272000,
    maxTokens: 128000,
    thinkingLevels: ["off", "minimal", "low", "medium", "high", "xhigh"],
    async route(request, ctx) {
      let provider = request.state?.provider;
      if (!provider) {
        try {
          await checkLiteLLM(request.signal);
          provider = "litellm_tvlk";
        } catch (error) {
          if (request.signal.aborted) throw error;
          provider = "openai-codex";
          const reason = error instanceof Error ? error.message : String(error);
          ctx.ui.notify(`LiteLLM unavailable (${reason}); using Codex for the subagent.`, "warning");
        }
      }
      const model = ctx.modelRegistry.find(provider, "gpt-6-luna");
      if (!model) throw new Error(`Model ${provider}/gpt-6-luna is unavailable`);
      return { model, thinkingLevel: request.thinkingLevel, state: request.state ?? { provider } };
    },
  });

  pi.on("session_start", async (event, ctx) => {
    if (
      event.reason !== "startup" ||
      process.argv.some((arg) =>
        ["-c", "--continue", "-r", "--resume", "--session", "--fork"].some((flag) => arg === flag || arg.startsWith(`${flag}=`)),
      ) ||
      ctx.sessionManager.getEntries().some((entry) => entry.type === "message") ||
      process.argv.some((arg) =>
        ["--model", "--models"].some((flag) => arg === flag || arg.startsWith(`${flag}=`)),
      )
    ) return;

    if (!baseUrl || !apiKey) {
      ctx.ui.notify("LiteLLM endpoint or API key is missing; keeping the configured model.", "warning");
      return;
    }

    try {
      await checkLiteLLM();
      const model = ctx.modelRegistry.find("litellm_tvlk", "gpt-6.1-terra");
      if (!model || !(await pi.setModel(model))) throw new Error("LiteLLM model is unavailable or has no credentials");
      ctx.ui.notify("Using LiteLLM gpt-6.1-terra.", "info");
    } catch (error) {
      const reason = error instanceof Error ? error.message : String(error);
      ctx.ui.notify(`LiteLLM unavailable (${reason}); keeping the configured model.`, "warning");
    }
  });

  if (baseUrl && apiKey)
    pi.registerProvider("litellm_tvlk", {
      name: "LiteLLM TVLK",
      baseUrl,
      apiKey: "$LITELLM_API_KEY",
      api: "openai-completions",
      // Chat catalog, limits, and USD per-million-token prices reported by the proxy.
      models: [
        {
          id: "claude-haiku-4.5",
          contextWindow: 200000,
          maxTokens: 64000,
          cost: { input: 1, output: 5, cacheRead: 0.1, cacheWrite: 1.25 },
        },
        {
          id: "claude-haiku-5.5",
          contextWindow: 1000000,
          maxTokens: 128000,
          cost: { input: 0.1, output: 0.5, cacheRead: 0.01, cacheWrite: 0.125 },
        },
        {
          id: "claude-opus-4.7",
          contextWindow: 1000000,
          maxTokens: 128000,
          cost: { input: 5, output: 25, cacheRead: 0.5, cacheWrite: 6.25 },
        },
        {
          id: "claude-opus-4.8",
          contextWindow: 1000000,
          maxTokens: 128000,
          cost: { input: 5, output: 25, cacheRead: 0.5, cacheWrite: 6.25 },
        },
        {
          id: "claude-opus-5",
          contextWindow: 1000000,
          maxTokens: 128000,
          cost: { input: 5, output: 25, cacheRead: 0.5, cacheWrite: 6.25 },
        },
        {
          id: "claude-opus-5.5",
          contextWindow: 1000000,
          maxTokens: 128000,
          cost: { input: 4, output: 20, cacheRead: 0.2, cacheWrite: 5 },
        },
        {
          id: "claude-sonnet-4-6@default",
          contextWindow: 1000000,
          maxTokens: 64000,
          cost: { input: 3, output: 15, cacheRead: 0.3, cacheWrite: 3.75 },
        },
        {
          id: "claude-sonnet-4.6",
          contextWindow: 1000000,
          maxTokens: 64000,
          cost: { input: 3, output: 15, cacheRead: 0.3, cacheWrite: 3.75 },
        },
        {
          id: "claude-sonnet-5",
          contextWindow: 1000000,
          maxTokens: 128000,
          cost: { input: 2, output: 10, cacheRead: 0.2, cacheWrite: 2.5 },
        },
        {
          id: "claude-sonnet-5.5",
          contextWindow: 1000000,
          maxTokens: 128000,
          cost: { input: 2, output: 10, cacheRead: 0.2, cacheWrite: 2.5 },
        },
        {
          id: "gpt-5.4",
          contextWindow: 1050000,
          maxTokens: 128000,
          cost: { input: 2.5, output: 15, cacheRead: 0.25, cacheWrite: 0 },
        },
        {
          id: "gpt-5.4-mini",
          contextWindow: 272000,
          maxTokens: 128000,
          cost: { input: 0.75, output: 4.5, cacheRead: 0.075, cacheWrite: 0 },
        },
        {
          id: "gpt-5.5",
          contextWindow: 1050000,
          maxTokens: 128000,
          cost: { input: 5, output: 30, cacheRead: 0.5, cacheWrite: 0 },
        },
        {
          id: "gpt-5.6-luna",
          contextWindow: 922000,
          maxTokens: 128000,
          cost: { input: 0.2, output: 1.2, cacheRead: 0.02, cacheWrite: 0.25 },
        },
        {
          id: "gpt-5.6-sol",
          contextWindow: 922000,
          maxTokens: 128000,
          cost: { input: 4, output: 20, cacheRead: 0.4, cacheWrite: 5 },
        },
        {
          id: "gpt-5.6-terra",
          contextWindow: 922000,
          maxTokens: 128000,
          cost: { input: 2, output: 12, cacheRead: 0.2, cacheWrite: 2.5 },
        },
        {
          id: "gpt-6-astra",
          contextWindow: 922000,
          maxTokens: 128000,
          cost: { input: 10, output: 50, cacheRead: 1, cacheWrite: 12.5 },
        },
        {
          id: "gpt-6-luna",
          contextWindow: 922000,
          maxTokens: 128000,
          cost: { input: 0.1, output: 0.5, cacheRead: 0.01, cacheWrite: 0.125 },
        },
        {
          id: "gpt-6-sol",
          contextWindow: 922000,
          maxTokens: 128000,
          cost: { input: 2, output: 10, cacheRead: 0.2, cacheWrite: 2.5 },
        },
        {
          id: "gpt-6.1-sol",
          contextWindow: 922000,
          maxTokens: 128000,
          cost: { input: 2, output: 10, cacheRead: 0.1, cacheWrite: 2.5 },
        },
        {
          id: "gpt-6.1-terra",
          contextWindow: 922000,
          maxTokens: 128000,
          cost: { input: 1, output: 5, cacheRead: 0.05, cacheWrite: 1.25 },
        },
        {
          id: "gpt-oss-120b",
          contextWindow: 128000,
          maxTokens: 16384,
          cost: { input: 0.15, output: 0.6, cacheRead: 0, cacheWrite: 0 },
        },
        {
          id: "grok-4.7",
          contextWindow: 524288,
          maxTokens: 524288,
          cost: { input: 2, output: 6, cacheRead: 0.5, cacheWrite: 0 },
        },
        {
          id: "kimi-k3",
          contextWindow: 1000000,
          maxTokens: 131072,
          cost: { input: 3, output: 15, cacheRead: 0.3, cacheWrite: 3.75 },
        },
      ].map((model) => ({
        ...model,
        name: model.id,
        reasoning: true,
        input: model.id === "gpt-oss-120b" ? ["text"] : ["text", "image"],
      })),
    });
}
