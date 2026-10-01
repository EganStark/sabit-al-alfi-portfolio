import type { APIRoute } from 'astro';
import { createCmsClient } from '../../../../lib/cms/supabase';

export const GET: APIRoute = async ({ request, cookies, redirect }) => {
  const code = new URL(request.url).searchParams.get('code');
  const supabase = createCmsClient(request, cookies);
  if (!code || !supabase) return redirect('/admin/login?error=recovery');

  const { error } = await supabase.auth.exchangeCodeForSession(code);
  return redirect(error ? '/admin/login?error=recovery' : '/admin/reset-password');
};
