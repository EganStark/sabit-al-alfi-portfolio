import type { APIRoute } from 'astro';
import { createCmsClient } from '../../../lib/cms/supabase';

export const POST: APIRoute = async ({ request, cookies, redirect }) => {
  const supabase = createCmsClient(request, cookies);
  if (!supabase) return redirect('/admin/login?error=recovery');

  const form = await request.formData();
  const email = String(form.get('email') ?? '').trim();
  if (!email || !email.includes('@')) return redirect('/admin/login?error=recovery');

  const origin = new URL(request.url).origin;
  const { error } = await supabase.auth.resetPasswordForEmail(email, {
    redirectTo: `${origin}/api/admin/auth/callback`,
  });

  return redirect(error ? '/admin/login?error=recovery' : '/admin/login?recovery=sent');
};
