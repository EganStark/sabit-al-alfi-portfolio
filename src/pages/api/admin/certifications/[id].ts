import type { APIRoute } from 'astro';
import { createCmsClient } from '../../../../lib/cms/supabase';

export const POST: APIRoute = async ({ request, cookies, params, redirect, locals }) => {
  if (!locals.cmsUser) return new Response('Unauthorized', { status: 401 });
  const form = await request.formData();
  const title = String(form.get('title') ?? '').trim();
  const provider = String(form.get('provider') ?? '').trim();
  const status = String(form.get('status') ?? 'in_progress');
  if (title.length < 2 || provider.length < 2 || !['completed','in_progress'].includes(status)) return new Response('Invalid certification data', { status: 400 });
  const issuedAt = String(form.get('issued_at') ?? '').trim();
  const payload = { title, provider, status, description: String(form.get('description') ?? '').trim().slice(0,500), credential_url: String(form.get('credential_url') ?? '').trim() || null, issued_at: issuedAt || null, sort_order: Math.max(0, Math.min(999, Number(form.get('sort_order')) || 0)), visible: form.get('visible') === 'true' };
  const supabase = createCmsClient(request, cookies)!;
  const query = params.id === 'new' ? supabase.from('certifications').insert(payload) : supabase.from('certifications').update(payload).eq('id', params.id);
  const { error } = await query;
  if (error) return new Response(error.message, { status: 400 });
  return redirect('/admin/certifications');
};

