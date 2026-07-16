import type { APIRoute } from 'astro';
import { createCmsClient } from '../../../lib/cms/supabase';

export const POST: APIRoute = async ({ request, cookies, redirect }) => {
  await createCmsClient(request, cookies)?.auth.signOut();
  return redirect('/admin/login');
};

