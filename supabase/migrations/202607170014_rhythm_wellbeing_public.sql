update public.projects
set
  status = 'Complete',
  description = 'A privacy-first wellbeing journal for logging time, understanding personal rhythms, receiving grounded AI reflections, and sharing opt-in insights through trusted Circles.',
  tags = array['React','TypeScript','Supabase','Groq AI'],
  live_url = 'https://rhythm-wellbeing.vercel.app',
  github_url = 'https://github.com/EganStark/rhythm-wellbeing',
  source_visibility = 'Public',
  visible = true
where title = 'Rhythm Wellbeing';
