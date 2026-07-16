import { createServerClient, parseCookieHeader } from '@supabase/ssr';
import type { AstroCookies } from 'astro';
import { getCmsConfig } from './config';

export function createCmsClient(request: Request, cookies: AstroCookies) {
  const config = getCmsConfig();
  if (!config.configured || !config.url || !config.publishableKey) return null;

  return createServerClient(config.url, config.publishableKey, {
    cookies: {
      getAll() {
        return parseCookieHeader(request.headers.get('cookie') ?? '');
      },
      setAll(cookiesToSet) {
        for (const { name, value, options } of cookiesToSet) {
          cookies.set(name, value, options);
        }
      },
    },
  });
}

