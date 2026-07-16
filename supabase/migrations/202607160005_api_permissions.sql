-- Explicit Data API privileges for a project with automatic table exposure disabled.
-- Row Level Security policies remain the final authorization boundary.

grant usage on schema public to anon, authenticated;
revoke all on function public.is_cms_admin() from public;
grant execute on function public.is_cms_admin() to anon, authenticated;

do $$
declare
  table_name text;
begin
  if to_regclass('public.cms_admins') is not null then
    grant select on public.cms_admins to authenticated;
  end if;

  foreach table_name in array array['posts', 'certifications', 'projects', 'research_papers', 'profile_content', 'education_records', 'skill_groups', 'coursework', 'thesis_content', 'community_entries', 'contact_content', 'social_links', 'site_settings']
  loop
    if to_regclass('public.' || table_name) is not null then
      execute format('grant select on public.%I to anon, authenticated', table_name);
      execute format('grant insert, update, delete on public.%I to authenticated', table_name);
      execute format('revoke insert, update, delete on public.%I from anon', table_name);
    end if;
  end loop;
end
$$;
