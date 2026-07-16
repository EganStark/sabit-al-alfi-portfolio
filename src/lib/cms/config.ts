export function getCmsConfig() {
  const url = import.meta.env.PUBLIC_SUPABASE_URL?.trim();
  const publishableKey = import.meta.env.PUBLIC_SUPABASE_PUBLISHABLE_KEY?.trim();

  return {
    configured: Boolean(url && publishableKey),
    url,
    publishableKey,
  };
}

