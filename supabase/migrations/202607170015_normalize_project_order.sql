with ordered_projects as (
  select
    id,
    row_number() over (
      order by
        case title
          when 'FetalCareXAI' then 1
          when 'Rhythm Wellbeing' then 2
          when 'REMP' then 3
          when 'Sabit Al Alfi Portfolio & CMS' then 4
          when 'Explainable CNN for Nitrogen Deficiency' then 5
          when 'Baitur Rahman Jame Mosjid Admin Panel' then 6
          when 'Emergency Ambulance Service' then 7
          when 'FIFA World Cup 2026 Schedule App' then 8
          when '2D Solar Energy System Simulation' then 9
          else 1000 + sort_order
        end,
        created_at,
        id
    ) as normalized_order
  from public.projects
)
update public.projects as project
set sort_order = ordered_projects.normalized_order::integer
from ordered_projects
where project.id = ordered_projects.id;
