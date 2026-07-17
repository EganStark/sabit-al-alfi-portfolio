import type { APIRoute } from 'astro';
import { createCmsClient } from '../../../../../lib/cms/supabase';

export const POST: APIRoute = async ({ request, cookies, params, redirect, locals }) => {
  if (!locals.cmsUser) return new Response('Unauthorized', { status: 401 });

  const cms = createCmsClient(request, cookies)!;
  const { error: deleteError } = await cms.from('projects').delete().eq('id', params.id);
  if (deleteError) return new Response(deleteError.message, { status: 400 });

  const { data: projects, error: readError } = await cms
    .from('projects')
    .select('id')
    .order('sort_order')
    .order('created_at');
  if (readError) return new Response(readError.message, { status: 400 });

  for (let index = 0; index < (projects ?? []).length; index += 1) {
    const { error } = await cms.from('projects').update({ sort_order: index + 1 }).eq('id', projects![index].id);
    if (error) return new Response(error.message, { status: 400 });
  }

  return redirect('/admin/projects');
};
