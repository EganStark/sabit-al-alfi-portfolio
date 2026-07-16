import type { APIRoute } from 'astro';
import { createCmsClient } from '../../../../lib/cms/supabase';

function slugify(value: string) {
  return value.toLowerCase().trim().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');
}

export const POST: APIRoute = async ({ request, cookies, params, redirect, locals }) => {
  if (!locals.cmsUser) return new Response('Unauthorized', { status: 401 });
  const supabase = createCmsClient(request, cookies)!;
  const form = await request.formData();
  const title = String(form.get('title') ?? '').trim();
  const slug = slugify(String(form.get('slug') ?? '') || title);
  const status = String(form.get('status') ?? 'draft');
  if (title.length < 3 || !slug || !['draft','published','scheduled'].includes(status)) return new Response('Invalid post data', { status: 400 });

  let coverUrl: string | undefined;
  const cover = form.get('cover_file');
  if (cover instanceof File && cover.size > 0) {
    if (cover.size > 5 * 1024 * 1024 || !['image/jpeg','image/png','image/webp','image/avif'].includes(cover.type)) return new Response('Invalid cover image', { status: 400 });
    const extension = cover.name.split('.').pop()?.toLowerCase() ?? 'jpg';
    const filePath = `posts/${crypto.randomUUID()}.${extension}`;
    const { error: uploadError } = await supabase.storage.from('cms-media').upload(filePath, cover, { contentType: cover.type, upsert: false });
    if (uploadError) return new Response(uploadError.message, { status: 500 });
    coverUrl = supabase.storage.from('cms-media').getPublicUrl(filePath).data.publicUrl;
  }

  const publishedInput = String(form.get('published_at') ?? '').trim();
  const payload = {
    title,
    slug,
    excerpt: String(form.get('excerpt') ?? '').trim().slice(0, 320),
    body: String(form.get('body') ?? '').trim(),
    cover_alt: String(form.get('cover_alt') ?? '').trim() || null,
    tags: String(form.get('tags') ?? '').split(',').map(tag => tag.trim()).filter(Boolean).slice(0, 12),
    status,
    featured: form.get('featured') === 'true',
    published_at: publishedInput ? new Date(publishedInput).toISOString() : status === 'published' ? new Date().toISOString() : null,
    ...(coverUrl ? { cover_url: coverUrl } : {}),
  };

  const query = params.id === 'new'
    ? supabase.from('posts').insert({ ...payload, author_id: locals.cmsUser.id })
    : supabase.from('posts').update(payload).eq('id', params.id);
  const { error } = await query;
  if (error) return new Response(error.message, { status: 400 });
  return redirect('/admin/posts');
};

