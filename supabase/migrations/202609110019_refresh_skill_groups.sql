begin;

delete from public.skill_groups;

insert into public.skill_groups (title, skills, sort_order, visible) values
(
  'Languages & engineering',
  array['Python','C','C++','TypeScript','JavaScript','SQL'],
  1,
  true
),
(
  'Machine learning & analysis',
  array['PyTorch','TensorFlow','scikit-learn','Pandas','NumPy','Grad-CAM','LIME'],
  2,
  true
),
(
  'Product & infrastructure',
  array['React','Astro','Node.js','Vite','Supabase','PostgreSQL','Git','Vercel'],
  3,
  true
),
(
  'Data & research tools',
  array['Data cleaning','EDA','Matplotlib','Seaborn','LaTeX','Excel'],
  4,
  true
);

commit;
