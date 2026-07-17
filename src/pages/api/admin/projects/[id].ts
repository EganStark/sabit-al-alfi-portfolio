import type { APIRoute } from 'astro';
import { createCmsClient } from '../../../../lib/cms/supabase';

export const POST: APIRoute = async ({ request, cookies, params, redirect, locals }) => {
  if (!locals.cmsUser) return new Response('Unauthorized', { status: 401 });

  const form = await request.formData();
  const requestedOrder = Math.max(1, Number(form.get('sort_order')) || 1);
  const payload = {
    title: String(form.get('title') ?? '').trim(),
    category: String(form.get('category')),
    status: String(form.get('status')),
    description: String(form.get('description') ?? '').trim(),
    tags: String(form.get('tags') ?? '').split(',').map((tag) => tag.trim()).filter(Boolean),
    github_url: String(form.get('github_url') ?? '').trim() || null,
    live_url: String(form.get('live_url') ?? '').trim() || null,
    source_visibility: String(form.get('source_visibility')),
    featured: form.get('featured') === 'true',
    visible: form.get('visible') === 'true',
    sort_order: requestedOrder,
  };

  if (payload.title.length < 2) return new Response('Invalid project', { status: 400 });

  const cms = createCmsClient(request, cookies)!;
  const { data: projects, error: readError } = await cms
    .from('projects')
    .select('id, sort_order, created_at')
    .order('sort_order')
    .order('created_at');

  if (readError) return new Response(readError.message, { status: 400 });

  const isCreate = params.id === 'new';
  const currentId = String(params.id);
  const orderedIds = (projects ?? [])
    .filter((project) => isCreate || project.id !== currentId)
    .map((project) => project.id);
  const insertionIndex = Math.min(requestedOrder - 1, orderedIds.length);

  if (!isCreate) orderedIds.splice(insertionIndex, 0, currentId);
  payload.sort_order = insertionIndex + 1;

  if (isCreate) {
    for (let index = 0; index < orderedIds.length; index += 1) {
      const nextOrder = index < insertionIndex ? index + 1 : index + 2;
      const { error } = await cms.from('projects').update({ sort_order: nextOrder }).eq('id', orderedIds[index]);
      if (error) return new Response(error.message, { status: 400 });
    }

    const { error } = await cms.from('projects').insert(payload);
    if (error) return new Response(error.message, { status: 400 });
  } else {
    for (let index = 0; index < orderedIds.length; index += 1) {
      if (orderedIds[index] === currentId) continue;
      const { error } = await cms.from('projects').update({ sort_order: index + 1 }).eq('id', orderedIds[index]);
      if (error) return new Response(error.message, { status: 400 });
    }

    const { error } = await cms.from('projects').update(payload).eq('id', currentId);
    if (error) return new Response(error.message, { status: 400 });
  }

  return redirect('/admin/projects');
};
