import { defineMiddleware } from 'astro:middleware';
import { createCmsClient } from './lib/cms/supabase';
import { getCmsConfig } from './lib/cms/config';

export const onRequest = defineMiddleware(async (context, next) => {
  const config = getCmsConfig();
  context.locals.cmsConfigured = config.configured;
  context.locals.cmsUser = null;

  if (!config.configured) return next();

  const supabase = createCmsClient(context.request, context.cookies);
  const { data } = await supabase!.auth.getUser();
  context.locals.cmsUser = data.user ?? null;

  const protectedRoute = context.url.pathname.startsWith('/admin') && context.url.pathname !== '/admin/login';
  const publicAdminApi = context.url.pathname === '/api/admin/login';
  const protectedApi = context.url.pathname.startsWith('/api/admin/') && !publicAdminApi;

  if ((protectedRoute || protectedApi) && !context.locals.cmsUser) {
    if (protectedApi) return Response.json({ error: 'Unauthorized' }, { status: 401 });
    return context.redirect('/admin/login');
  }

  return next();
});
