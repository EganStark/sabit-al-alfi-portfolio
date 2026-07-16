import type { APIRoute } from 'astro';
import { createCmsClient } from '../../../../../lib/cms/supabase';

const tables = { education: 'education_records', skills: 'skill_groups', coursework: 'coursework' } as const;
const text = (form: FormData, key: string, max = 240) => String(form.get(key) ?? '').trim().slice(0, max);

export const POST: APIRoute = async ({ request, cookies, params, redirect, locals }) => {
  if (!locals.cmsUser) return new Response('Unauthorized', { status: 401 });
  const type = params.type as keyof typeof tables;
  const table = tables[type];
  if (!table) return new Response('Unknown content type', { status: 404 });
  const form = await request.formData();
  const cms = createCmsClient(request, cookies)!;
  if (form.get('intent') === 'delete') {
    if (params.id === 'new') return new Response('Invalid record', { status: 400 });
    const { error } = await cms.from(table).delete().eq('id', params.id!);
    if (error) return new Response(error.message, { status: 400 });
    return redirect('/admin/content/education-skills');
  }
  const common = { sort_order: Math.max(0, Math.min(999, Number(form.get('sort_order')) || 0)), visible: form.get('visible') === 'true' };
  let payload: Record<string, unknown>;
  if (type === 'education') {
    payload = { ...common, period: text(form,'period',80), title: text(form,'title'), institution: text(form,'institution'), detail: text(form,'detail'), result: text(form,'result',100) };
    if (!payload.period || !payload.title || !payload.institution) return new Response('Period, qualification, and institution are required', { status: 400 });
  } else if (type === 'skills') {
    const skills = text(form,'skills',1000).split(',').map(value => value.trim()).filter(Boolean).slice(0,30);
    payload = { ...common, title: text(form,'title'), skills };
    if (!payload.title || !skills.length) return new Response('Group title and at least one skill are required', { status: 400 });
  } else {
    payload = { ...common, title: text(form,'title') };
    if (!payload.title) return new Response('Course title is required', { status: 400 });
  }
  const query = params.id === 'new' ? cms.from(table).insert(payload) : cms.from(table).update(payload).eq('id', params.id!);
  const { error } = await query;
  if (error) return new Response(error.message, { status: 400 });
  return redirect('/admin/content/education-skills');
};
