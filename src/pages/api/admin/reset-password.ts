import type { APIRoute } from 'astro';
import { createCmsClient } from '../../../lib/cms/supabase';

export const POST: APIRoute = async ({ request, cookies, redirect, locals }) => {
  if (!locals.cmsUser) return redirect('/admin/login?error=recovery');

  const form = await request.formData();
  const password = String(form.get('password') ?? '');
  const confirmation = String(form.get('confirmation') ?? '');
  if (password.length < 8 || password !== confirmation) {
    return redirect('/admin/reset-password?error=password');
  }

  const supabase = createCmsClient(request, cookies)!;
  const { error } = await supabase.auth.updateUser({ password });
  if (error) return redirect('/admin/reset-password?error=password');

  await supabase.auth.signOut();
  return redirect('/admin/login?reset=success');
};
