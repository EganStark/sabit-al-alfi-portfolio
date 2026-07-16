import type { APIRoute } from 'astro';
import { createCmsClient } from '../../../../../lib/cms/supabase';
export const POST: APIRoute = async ({ request, cookies, params, redirect, locals }) => {
  if (!locals.cmsUser) return new Response('Unauthorized', { status: 401 });
  const { error } = await createCmsClient(request, cookies)!.from('certifications').delete().eq('id', params.id);
  if (error) return new Response(error.message, { status: 400 });
  return redirect('/admin/certifications');
};

