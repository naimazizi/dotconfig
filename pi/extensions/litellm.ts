import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  const baseUrl = process.env.LITELLM_API_ENDPOINT?.trim();
  if (!baseUrl) throw new Error("Set LITELLM_API_ENDPOINT before starting Pi to enable LiteLLM TVLK.");

  pi.registerProvider("litellm_tvlk", {
    name: "LiteLLM TVLK",
    baseUrl,
    apiKey: "$LITELLM_API_KEY",
    api: "openai-completions",
    models: ["claude-opus-4.7", "claude-sonnet-4.6", "claude-haiku-4.5", "claude-sonnet-5"].map((id) => ({
      id,
      name: id,
      reasoning: false,
      input: ["text", "image"],
      // shortcut: proxy pricing and limits are unknown; replace conservative limits and zero costs when verified.
      cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
      contextWindow: 128000,
      maxTokens: 16384,
    })),
  });
}
