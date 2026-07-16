import type { APIRoute } from 'astro';
import { createCmsClient } from '../../../lib/cms/supabase';

export const POST: APIRoute = async ({ request, cookies, redirect }) => {
  const supabase = createCmsClient(request, cookies);
  if (!supabase) return redirect('/admin/login');
  const form = await request.formData();
  const email = String(form.get('email') ?? '').trim();
  const password = String(form.get('password') ?? '');
  const { error } = await supabase.auth.signInWithPassword({ email, password });
  return redirect(error ? '/admin/login?error=credentials' : '/admin');
};

