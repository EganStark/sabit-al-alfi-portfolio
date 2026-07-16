import type { APIRoute } from 'astro';
import { createCmsClient } from '../../../../lib/cms/supabase';
const value = (form: FormData, key: string, max = 300) => String(form.get(key) ?? '').trim().slice(0,max);
export const POST: APIRoute = async ({request,cookies,redirect,locals}) => {
  if (!locals.cmsUser) return new Response('Unauthorized',{status:401});
  const form = await request.formData();
  const payload = { id:'primary', section_headline:value(form,'section_headline'), title:value(form,'title'), subtitle:value(form,'subtitle',600), status:value(form,'status',80), institution:value(form,'institution'), discipline:value(form,'discipline'), supervisor:value(form,'supervisor'), year:Number(form.get('year'))||2025, related_url:value(form,'related_url',500)||null, visible:form.get('visible')==='true' };
  if (!payload.title || !payload.subtitle || !payload.institution) return new Response('Required thesis fields are missing',{status:400});
  const {error}=await createCmsClient(request,cookies)!.from('thesis_content').upsert(payload,{onConflict:'id'});
  if(error)return new Response(error.message,{status:400});
  return redirect('/admin/content/thesis-community');
};
