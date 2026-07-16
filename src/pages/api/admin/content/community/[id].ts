import type { APIRoute } from 'astro';
import { createCmsClient } from '../../../../../lib/cms/supabase';
const value=(form:FormData,key:string,max=300)=>String(form.get(key)??'').trim().slice(0,max);
export const POST:APIRoute=async({request,cookies,params,redirect,locals})=>{
  if(!locals.cmsUser)return new Response('Unauthorized',{status:401});
  const form=await request.formData(),cms=createCmsClient(request,cookies)!;
  if(form.get('intent')==='delete'){
    if(params.id==='new')return new Response('Invalid entry',{status:400});
    const{error}=await cms.from('community_entries').delete().eq('id',params.id!);if(error)return new Response(error.message,{status:400});
  }else{
    const payload={organization:value(form,'organization'),role_period:value(form,'role_period',160),description:value(form,'description',500),url:value(form,'url',500)||null,sort_order:Math.max(0,Math.min(999,Number(form.get('sort_order'))||0)),visible:form.get('visible')==='true'};
    if(!payload.organization)return new Response('Organization is required',{status:400});
    const query=params.id==='new'?cms.from('community_entries').insert(payload):cms.from('community_entries').update(payload).eq('id',params.id!);const{error}=await query;if(error)return new Response(error.message,{status:400});
  }
  return redirect('/admin/content/thesis-community');
};
